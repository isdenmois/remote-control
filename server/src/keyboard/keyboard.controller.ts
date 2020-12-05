import { Controller, Post, Query } from '@nestjs/common';
import { ApiQuery, ApiTags } from '@nestjs/swagger';
import { KeyboardService } from './keyboard.service';

@ApiTags('Keyboard')
@Controller()
export class KeyboardController {
  constructor(private keyboardService: KeyboardService) { }

  @Post('keypress')
  @ApiQuery({ name: 'modifiers', isArray: true, required: false })
  keyTap(@Query('key') key: string, @Query('modifiers') modifiers: string | string[]) {
    this.keyboardService.keyTap(key, modifiers);
  }
}
