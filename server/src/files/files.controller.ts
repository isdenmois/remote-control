import { Controller, Get, Post, Query } from '@nestjs/common';
import { ApiQuery, ApiTags } from '@nestjs/swagger';
import { FilesService } from './files.service';

@ApiTags('Files')
@Controller('files')
export class FilesController {
  constructor(private filesService: FilesService) {
  }

  @Get('list')
  @ApiQuery({ name: 'dir', required: false })
  filesList(@Query('dir') dir?: string) {
    return this.filesService.list(dir);
  }

  @Post('open')
  openFile(@Query('path') path: string) {
    return this.filesService.open(path);
  }
}
