from ocifs import OCIFileSystem

import click

@click.group()
def cli(): pass

REMOTE = click.argument("remote")

MB = 1024 ** 2
def slowCopy(src, dest):
    while True:
        hunk = src.read(MB)
        if not hunk: break
        dest.write(hunk)

@cli.command()
@REMOTE
@click.argument("local", type=click.File("wb"))
def getFromSource(remote, local):
    fs = OCIFileSystem(config="~/.oci/config", profile="DEFAULT")
    with fs.open(remote, "rb") as handle: slowCopy(handle, local)

@cli.command()
@click.argument("local", type=click.File("rb"))
@REMOTE
def sendToSource(local, remote):
    fs = OCIFileSystem(config="~/.oci/config", profile="DEFAULT")
    with fs.open(remote, "wb") as handle: slowCopy(local, handle)

main = cli
