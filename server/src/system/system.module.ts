import { Module } from '@nestjs/common';
import { ConfigModule, ConfigService } from '@nestjs/config';
import { SystemService } from './system.service';
import { SystemController } from './system.controller';
import { FakeSystemService } from './system.fake.service';

@Module({
  imports: [ConfigModule],
  controllers: [SystemController],
  providers: [
    {
      provide: SystemService,
      inject: [ConfigService],
      useFactory(configService: ConfigService) {
        const useFake = configService.get('FAKE_SYSTEM', false);

        return useFake ? new FakeSystemService() : new SystemService();
      },
    },
  ],
})
export class SystemModule {}
