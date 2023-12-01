###
#
# Copyright Computelify, Inc.
#
# This trains and builds an index.
#
# Author: Steven Dake <steve@computelify.com>
# License: ASL2.

import subprocess
import pathlib

def get_base_path() -> pathlib.Path:
    """
    Get base path.
    """
    return pathlib.Path(__file__).parent.parent.resolve()

def get_mouseion_source_path() -> pathlib.Path:
    """
    Get Mousieon source path.
    """
    return get_base_path / "mouseon"

def build_workload(base_path: pathlib.Path) -> list:
    """
    Constructs the command as a list of arguments to be executed.

    Args:
        base_path (pathlib.Path): The base path of the project.

    Returns:
        list: The command as a list of arguments.
    """
    datacollection_specs_path = base_path / "datacollection_specs"
    realnews_path = base_path / "knowledge.d/realnews.d"
    mouseion_source_path = base_path / "mouseion"

    # The hyperfine bench tool requires a single string command.
    workload_cmd = (
        f"python '{mouseion_source_path / 'train_and_build_index.py'}' "
        f"--spec '{datacollection_specs_path / 'train_realnews_dataset_spec.json'}' "
        f"--index-type IVF131072,PQ32 "
        f"--output '{realnews_path / 'realnews.mouseion'}' "
        f"--use-gpus "
        f"--batch-size 32768"
    )

    # Bench launcher
    bench_launcher = [
        "hyperfine",
        "--runs", "1",
        "--warmup", "0",
        "--show-output",
        "--time-unit", "second",
        "--command-name", "train-index",
        workload_cmd
    ]

    return bench_launcher

def run_workload(command: list) -> None:
    """
    Runs the given command using the subprocess module.

    Args:
        command (list): The command as a list of arguments to execute.
    """
    subprocess.run(command, check=True)

def main() -> None:
    base_path = get_base_path()
    command = build_workload(base_path)
    run_workload(command)

if __name__ == "__main__":
    main()
