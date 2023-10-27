import pyarrow.feather, pyarrow.json

from ocifs import OCIFileSystem

import click

@click.group()
def cli(): pass

@cli.command()
@click.argument("remote")
@click.argument("local", type=click.File("wb"))
def getFromSource(remote, local):
    fs = OCIFileSystem(config="~/.oci/config", profile="DEFAULT")
    with fs.open(remote, "rb") as handle:
        df = pyarrow.feather.read_feather(handle)
        # DataFrame -> JSON Lines: https://stackoverflow.com/a/45570174/264985
        df.to_json(local, orient="records", lines=True)

@cli.command()
@click.argument("local", type=click.File("rb"))
@click.argument("remote")
def sendToSource(local, remote):
    fs = OCIFileSystem(config="~/.oci/config", profile="DEFAULT")
    with fs.open(remote, "wb") as handle:
        df = pyarrow.json.read_json(local)
        pyarrow.feather.write_feather(df, handle, compression="zstd")

main = cli

if __name__ == "__main__": raise SystemExit(main())
