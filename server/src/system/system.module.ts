import { SystemService } from './system.service';
import { SystemController } from './system.controller';
import { Module } from '@nestjs/common';

@Module({
    imports: [],
    controllers: [
        SystemController,],
    providers: [
        SystemService,],
})
export class SystemModule { }
