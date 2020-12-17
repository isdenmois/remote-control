import { Injectable } from '@nestjs/common';
import { spawn } from 'promisify-child-process';
import * as path from 'path';
import { tmpdir } from 'os';
import { promises } from 'fs';
import * as parseCSV from 'csv-parse/lib/sync';
import { Device, Switch } from './system.types';

const readFile = promises.readFile;

@Injectable()
export class SystemService {
  private tmpAudioFile = path.join(tmpdir(), 'a.txt');
  private tmpDisplayFile = path.join(tmpdir(), 'd.txt');

  shutdown() {
    const args = ['/s', '/d', 'u:4:5', '/f', '/t', '0'];
    const prog = path.join(process.env.SystemRoot, 'System32', 'shutdown.exe');

    spawn(prog, args, {});
  }

  async getAudio() {
    await spawn('SoundVolumeView.exe', ['/scomma', this.tmpAudioFile], {});
    const data = await readFile(this.tmpAudioFile, { encoding: 'utf-8' });

    const result: Device[] = parseCSV(data, { columns: true, skip_empty_lines: true })
      .filter(r => r['Device State'] === 'Active' && r.Direction === 'Render')
      .map(row => ({ id: row['Item ID'], title: row.Name, selected: row.Default === 'Render' }));

    return result;
  }

  async getDisplays() {
    await spawn('MultiMonitorTool.exe', ['/scomma', this.tmpDisplayFile], {});
    const data = await readFile(this.tmpDisplayFile, { encoding: 'utf-8' });

    const result: Device[] = parseCSV(data, { columns: true, skip_empty_lines: true })
      .filter(m => m.Disconnected === 'No')
      .map(row => ({
        id: row.Name,
        title: row['Monitor Name'],
        selected: row.Active === 'Yes',
      }));

    return result;
  }

  async getDevices() {
    const [audio, displays] = await Promise.all([this.getAudio(), this.getDisplays()]);

    return { audio, displays };
  }

  async setAudio(audio: string) {
    console.log('Set audio to: ', audio);
    await spawn('SoundVolumeView.exe', ['/SetDefault', audio, 'all']);
  }

  async setDisplay(display: string) {
    console.log('Set video to: ', display);
    await spawn('MultiMonitorTool.exe', ['/switch', display]);
  }

  async displaySwitch(type: Switch) {
    await spawn('DisplaySwitch', [`/${type}`], {});
  }
}
