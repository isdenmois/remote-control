import { Injectable } from '@nestjs/common';
import * as robot from 'robotjs';

robot.setKeyboardDelay(2);

@Injectable()
export class KeyboardService {
  keyTap(key: string, modifiers?: string | string[]) {
    if (modifiers) {
      robot.keyTap(key, modifiers);
    } else {
      robot.keyTap(key);
    }
  }

  private getModifiers(modifiers: string | string[]): string[] {
    return Array.isArray(modifiers) ? modifiers : [modifiers];
  }
}
