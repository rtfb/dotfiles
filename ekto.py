#!/usr/bin/env python

import os
import sys
import zipfile


def main():
    dry_run = False
    input_file = sys.argv[1]
    if sys.argv[1] == '-n':
        dry_run = True
        input_file = sys.argv[2]
    bn = os.path.basename(input_file)
    bn = os.path.splitext(bn)[0]
    parts = bn.split(' - ')
    if parts[0] == 'VA':
        unzip_path = ' - '.join(parts[:-1])
    else:
        unzip_path = os.path.join(parts[0], parts[2] + ' - ' + parts[1])
    mus = os.environ['MUSIC_DIR']
    path = os.path.join(mus, unzip_path)
    if not dry_run:
        os.makedirs(path)
    dry_prefix = ''
    if dry_run:
        dry_prefix = '[DRY] '
    print('%sUnzipping "%s" to "%s"...' % (dry_prefix, input_file, path))
    if not dry_run:
        z = zipfile.ZipFile(input_file)
        infolist = z.infolist()
        for zinfo in infolist:
            if zinfo.flag_bits & 0x800:
                out_file_name = zinfo.filename.decode('utf-8')
            else:
                out_file_name = zinfo.filename.decode('cp437')
            open(os.path.join(path, out_file_name), 'w').write(z.read(zinfo))


if __name__ == '__main__':
    main()
