import { SystemService } from './system.service';
import { Device } from './system.types';

export class FakeSystemService extends SystemService {
  audio: Device[] = [
    { id: 'benq', title: 'BenQ', selected: true },
    { id: 'realtek', title: 'Realtek', selected: false },
    { id: 'aaa', title: 'AAA-Sound', selected: false },
  ];
  video: Device[] = [
    { id: 'benq', title: 'BenQ 32', selected: true },
    { id: 'aaa', title: 'AAA-8', selected: false },
  ];

  async getAudio() {
    return this.audio;
  }

  async getDisplays() {
    return this.video;
  }

  async setAudio(id: string) {
    this.audio.forEach(device => {
      device.selected = device.id === id;
    });
  }

  async setDisplay(id: string) {
    this.video.forEach(device => {
      device.selected = device.id === id;
    });
  }
}
