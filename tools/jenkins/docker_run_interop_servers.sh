#!/bin/bash
# Copyright 2015, Google Inc.
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are
# met:
#
#     * Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#     * Redistributions in binary form must reproduce the above
# copyright notice, this list of conditions and the following disclaimer
# in the documentation and/or other materials provided with the
# distribution.
#     * Neither the name of Google Inc. nor the names of its
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
# "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
# LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
# A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
# OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
# SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
# LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
# DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
# THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
# (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# This script is invoked by run_jekins.sh. It contains the test logic
# that should run inside a docker container.
set -e

cd /var/local/git/grpc
nvm use 0.12
rvm use ruby-2.1

# If port env variable is set, run corresponding interop server on given port in background.
# TODO(jtattermusch): ideally, run_interop_tests.py would generate the commands to run servers.

[ -z "${SERVER_PORT_cxx}" ] || bins/opt/interop_server --enable_ssl --port=${SERVER_PORT_cxx} &

[ -z "${SERVER_PORT_node}" ] || node src/node/interop/interop_server.js --use_tls=true --port=${SERVER_PORT_node} &

[ -z "${SERVER_PORT_ruby}" ] || ruby src/ruby/bin/interop/interop_server.rb --use_tls --port=${SERVER_PORT_ruby} &

[ -z "${SERVER_PORT_csharp}" ] || (cd src/csharp/Grpc.IntegrationTesting.Server/bin/Debug && mono Grpc.IntegrationTesting.Server.exe --use_tls --port=${SERVER_PORT_csharp}) &

sleep infinity
