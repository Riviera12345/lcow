# SUMMARY: Create a symlink on a volume mount and check in container
# LABELS:
# REPEAT:

$libBase = Join-Path -Path $env:RT_PROJECT_ROOT -ChildPath _lib
$lib = Join-Path -Path $libBase -ChildPath lib.ps1
. $lib

$ret = 0

$imageName = $env:RT_TEST_NAME
$fileName = "foobar"
$linkName = "barfoo"

Remove-Item -Path $fileName -Force -Recurse -ErrorAction Ignore
Remove-Item -Path $linkName -Force -Recurse -ErrorAction Ignore

docker build --platform linux -t $imageName .
if ($lastexitcode -ne 0) {
    exit 1
}

$p = [string]$pwd.Path
docker run --rm -v  $p`:/test $imageName /symlink_test.sh /test/$fileName /test/$linkName

if ($lastexitcode -ne 0) { 
    $ret = 1
}

Remove-Item -Path $fileName -Force -Recurse -ErrorAction Ignore
Remove-Item -Path $linkName -Force -Recurse -ErrorAction Ignore
exit $ret
