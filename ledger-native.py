#!/usr/bin/env python
"""
Copyright (c) 2012 The Chromium Authors. All rights reserved.
Copyright (c) 2018 Zimmi
Use of this source code is governed by a BSD-style (MIT) license that can be
found in the LICENSE file.
"""
import struct
import os
import sys
import json
from subprocess import Popen, PIPE

# On Windows, the default I/O mode is O_TEXT. Set this to O_BINARY
# to avoid unwanted modifications of the input/output streams.
if sys.platform == "win32":
    import msvcrt
    msvcrt.setmode(sys.stdin.fileno(), os.O_BINARY)
    msvcrt.setmode(sys.stdout.fileno(), os.O_BINARY)

def send_message(message):
    """
    Send a message to the browser.
    """
    response = json.dumps(message).encode('utf-8')
    sys.stdout.write(struct.pack('I', len(response)))
    sys.stdout.write(response)
    sys.stdout.flush()

def handleCmd(cmd, stdin=""):
    cmd = "ledger -f - %s" % cmd
    try:
        p = Popen(cmd.split(' '), stdin=PIPE, stdout=PIPE, stderr=PIPE)
        outs, errs = p.communicate(bytearray(stdin, 'utf-8'))
        outs = outs.decode("utf-8")
        errs = errs.decode("utf-8")
    except Exception as e:
        outs = ""
        errs = e
    message = json.dumps({"output": outs, "error": errs})
    try:
        send_message(message)
    except Exception as e:
        send_message("error {0}".format(e))
        sys.exit(1)

def run():
    text_length_bytes = sys.stdin.read(4)

    if not text_length_bytes:
        send_message({"error", "no data"})
        sys.exit(1)
    length = struct.unpack('I', text_length_bytes)[0]
    data = sys.stdin.read(length)
    request = json.loads(data.decode('utf-8'))
    cmd = request["cmd"]
    stdin = ""
    if "stdin" in request:
        stdin = request["stdin"]
    handleCmd(cmd, stdin)


if __name__ == '__main__':
    if sys.argv[1].startswith('chrome-extension://fjnccnnmidoffkjhcnnahfeclbgoaooo'):
        run()
    elif sys.argv[1].startswith('{'):
        args = json.loads(sys.argv[1])
        handleCmd(**args)

