import * as _ from 'lodash';
import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { readdirSync } from 'fs';
import { join } from 'path';
import * as open from 'open';

@Injectable()
export class FilesService {
  constructor(private configService: ConfigService) { }

  private root = this.configService.get('FILES_HOME');

  list(dir: string) {
    const path = dir ? join(this.root, dir) : this.root;

    const files = readdirSync(path, { withFileTypes: true }).map(dirent => ({
      name: dirent.name,
      path: dir ? join(dir, dirent.name) : dirent.name,
      dir: dirent.isDirectory(),
    }));

    return _.orderBy(files, 'dir', 'desc');
  }

  open(path: string) {
    open(join(this.root, path));
  }
}
