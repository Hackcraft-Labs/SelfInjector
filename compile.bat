@ECHO OFF
python Blueprint\blueprint.py blueprint.json && ^
msbuild SelfInjector.sln /p:Configuration=Release /p:Platform="Any CPU" /p:Platform="x64"