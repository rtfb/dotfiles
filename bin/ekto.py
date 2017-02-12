#!/usr/bin/env python

import os
import shutil
import sys
import tempfile
import zipfile


def unzip_archive(archive):
    tmp_dir = tempfile.mkdtemp('', 'EKTOPLASM_')
    print('(via temp dir "%s")' % tmp_dir)
    z = zipfile.ZipFile(archive)
    infolist = z.infolist()
    for zinfo in infolist:
        if zinfo.flag_bits & 0x800:
            out_file_name = zinfo.filename.decode('utf-8')
        else:
            out_file_name = zinfo.filename.decode('cp437')
        open(os.path.join(tmp_dir, out_file_name), 'w').write(z.read(zinfo))
    return tmp_dir


def target_dir_from_archive_name(arch):
    bn = os.path.basename(arch)
    bn = os.path.splitext(bn)[0]
    parts = bn.split(' - ')
    if parts[0] == 'VA':
        return ' - '.join(parts[:-1])
    else:
        return os.path.join(parts[0], parts[2] + ' - ' + parts[1])


def main():
    dry_run = False
    input_file = sys.argv[1]
    if sys.argv[1] == '-n':
        dry_run = True
        input_file = sys.argv[2]
    unzip_path = target_dir_from_archive_name(input_file)
    mus = os.environ['MUSIC_DIR']
    path = os.path.join(mus, unzip_path)
    dry_prefix = ''
    if dry_run:
        dry_prefix = '[DRY] '
    print('%sUnpacking "%s" to "%s"...' % (dry_prefix, input_file, path))
    if not dry_run:
        shutil.move(unzip_archive(input_file), path)


if __name__ == '__main__':
    main()
