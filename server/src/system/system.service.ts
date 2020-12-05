import { Injectable } from '@nestjs/common';
import { spawn, spawnSync } from 'child_process';
import * as path from 'path';
import { readFileSync } from 'fs';
import parseCSV from 'csv-parse/lib/sync';
import { Device } from './system.types';

@Injectable()
export class SystemService {
  shutdown() {
    const args = ['/s', '/d', 'u:4:5', '/f', '/t', '0'];
    const prog = path.join(process.env.SystemRoot, 'System32', 'shutdown.exe');

    spawn(prog, args, {});
  }

  getAudio() {
    console.time('aaa');
    spawnSync('SoundVolumeView.exe', ['/scomma', '/tmp/s.txt'], {});
    const data = readFileSync('/tmp/s.txt', { encoding: 'utf-8' });

    const result: Device[] = parseCSV(data, { columns: true, skip_empty_lines: true })
      .filter(r => r['Device State'] === 'Active' && r.Direction === 'Render')
      .map(row => ({ id: row['Item ID'], title: row.Name, selected: row.Default === 'Render' }));

    console.timeEnd('aaa');

    return result;
  }

  getDisplays() {
    console.time('ddd');
    spawnSync('MultiMonitorTool.exe', ['/scomma', 's.txt'], {});
    const data = readFileSync('./s.txt', { encoding: 'utf-8' });

    const result: Device[] = parseCSV(data, { columns: true, skip_empty_lines: true })
      .filter(m => m.Disconnected === 'No')
      .map(row => ({
        id: row.Name,
        title: row['Monitor Name'],
        selected: row.Active === 'Yes',
      }));

    console.timeEnd('ddd');

    return result;
  }

  getDevices() {
    const audio = this.getAudio();
    const displays = this.getDisplays();

    return { audio, displays };
  }

  setAudio(audio: string) {
    console.log('Set audio to: ', audio);
    spawnSync('SoundVolumeView.exe', ['/SetDefault', audio, 'all']);
  }

  setDisplay(display: string) {
    console.log('Set video to: ', display);
    spawnSync('MultiMonitorTool.exe', ['/switch', display]);
  }
}
