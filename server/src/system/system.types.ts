import { ApiProperty, getSchemaPath } from "@nestjs/swagger";

export class Device {
  @ApiProperty() id: string;
  @ApiProperty() title: string;
  @ApiProperty() selected: boolean;
}

export const devicesSchema = {
  properties: {
    audio: {
      type: 'array',
      items: { $ref: getSchemaPath(Device) },
    },
    displays: {
      type: 'array',
      items: { $ref: getSchemaPath(Device) },
    },
  },
}
