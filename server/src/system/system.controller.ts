import { Controller, Get, Post, Query } from '@nestjs/common';
import { ApiExtraModels, ApiOkResponse, ApiQuery, ApiTags } from '@nestjs/swagger';
import { SystemService } from './system.service';
import { Device, devicesSchema, Switch } from './system.types';

@ApiTags('System')
@Controller()
@ApiExtraModels(Device)
export class SystemController {
  constructor(private systemService: SystemService) {}

  @Get('devices')
  @ApiOkResponse({ schema: devicesSchema })
  devices() {
    return this.systemService.getDevices();
  }

  @Post('set-audio')
  @ApiOkResponse({ schema: devicesSchema })
  setAudio(@Query('id') id: string) {
    this.systemService.setAudio(id);

    return this.systemService.getDevices();
  }

  @Post('set-display')
  @ApiOkResponse({ schema: devicesSchema })
  setDisplay(@Query('id') id: string) {
    this.systemService.setDisplay(id);

    return this.systemService.getDevices();
  }

  @Post('displayswitch')
  @ApiQuery({ name: 'type', enum: Switch })
  displaySwitch(@Query('type') type: Switch) {
    this.systemService.displaySwitch(type);
  }

  @Post('shutdown')
  shutdown() {
    this.systemService.shutdown();
  }
}
