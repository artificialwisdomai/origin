from enum import Enum
from rich.console import Console
from rich.progress import (
    Progress,
    TextColumn,
    BarColumn,
    TimeRemainingColumn,
    TimeElapsedColumn,
    ProgressColumn,
    DownloadColumn,
    Task as RichTask,
)
from rich.logging import RichHandler
from rich.theme import Theme
from rich.style import Style
import logging
import time
from multiprocessing import Process, Queue
from typing import Callable, List, Optional, Set, Dict

# Define colors for styling
COLOR_TEXT = "#00EA8C"
COLOR_EXTRA = "#EA8C00"
COLOR_EXTRENUOUS = "#0ACCF9"

# Define the theme
theme = Theme(
    {
        "aw.a": Style.parse(COLOR_TEXT),
        "aw.b": Style.parse(COLOR_EXTRA),
        "aw.c": Style.parse(COLOR_EXTRENUOUS),
        "repr.ellipsis": Style.parse(COLOR_TEXT),
        "repr.filename": Style.parse(COLOR_TEXT),
        "repr.path": Style.parse(COLOR_TEXT),
        "progress.data.speed": Style.parse(COLOR_TEXT),
        "progress.description": Style.parse(COLOR_TEXT),
        "progress.download": Style.parse(COLOR_TEXT),
        "progress.elapsed": Style.parse(COLOR_TEXT),
        "progress.filesize": Style.parse(COLOR_TEXT),
        "progress.filesize.total": Style.parse(COLOR_TEXT),
        "progress.percentage": Style.parse(COLOR_TEXT),
        "progress.remaining": Style.parse(COLOR_TEXT),
        "progress.spinner": Style.parse(COLOR_TEXT),
    }
)

# Configure logging
logging.basicConfig(level="INFO", format="%(message)s", handlers=[RichHandler()])

class ProgressType(Enum):
    MIBI_PER_SECOND = "MiB/s"
    ITERATIONS_PER_SECOND = "iterations/s"

class HumanReadableProgress(ProgressColumn):
    def render(self, task: RichTask) -> str:
        progress_type = task.fields.get("type")
        if progress_type == ProgressType.MIBI_PER_SECOND:
            return DownloadColumn().render(task)
        elif progress_type == ProgressType.ITERATIONS_PER_SECOND:
            completed = int(task.completed)
            elapsed = task.elapsed
            if elapsed == 0:
                return "0 iter/sec"
            ratio = completed / elapsed
            return f"{ratio:.0f} iter/sec"
        return ""

class Task:
    def __init__(
        self,
        id: int,
        description: str,
        size: int,
        process_function: Callable[[int, Queue], float],
        progress_type: ProgressType,
        dependencies: Optional[List[int]] = None,
    ):
        self.id = id
        self.description = description
        self.size = size
        self.process_function = process_function
        self.progress_type = progress_type
        self.dependencies = dependencies if dependencies else []
        self.progress = 0
        self.queue = Queue()

    def is_ready(self, completed_tasks: Set[int]) -> bool:
        return all(dep in completed_tasks for dep in self.dependencies)

class TaskProcessor:
    def __init__(self, command: str, max_workers: int = 4):
        self.console = Console(theme=theme)
        self.logger = logging.getLogger("rich")
        self.max_workers = max_workers
        self.all_tasks: List[Task] = []  # Maintain a list of all tasks
        self.tasks: List[Task] = []  # Tasks that are yet to be started
        self.completed_tasks: Set[int] = set()
        self.console.print(f'[aw.c]Artificial Wisdom™ NLP Tools [/aw.c][aw.b]•[/aw.b] [aw.c]{command}[/aw.c]')

    def add_tasks(self, tasks: List[Task]) -> None:
        self.all_tasks.extend(tasks)
        self.tasks.extend(tasks)

    def process_tasks(self) -> None:
        with Progress(
            TextColumn("•", style="aw.b"),
            TextColumn("[progress.description]{task.description}"),
            TextColumn("•", style="aw.b"),
            BarColumn(style="aw.a", complete_style="aw.b"),
            TextColumn("•", style="aw.b"),
            TimeRemainingColumn(),
            TextColumn("•", style="aw.b"),
            TimeElapsedColumn(),
            TextColumn("•", style="aw.b"),
            TextColumn("[progress.percentage]{task.percentage:>3.0f}%"),
            TextColumn("•", style="aw.b"),
            HumanReadableProgress(),
            TextColumn("•", style="aw.b"),
            console=self.console,
        ) as progress:
            task_progress_map: Dict[int, int] = {task.id: progress.add_task(
                f'{task.description}',
                total=task.size,
                fields={'type': task.progress_type}
            ) for task in self.all_tasks}
            processes = []
            while self.tasks or processes:
                # Start ready tasks
                ready_tasks = [t for t in self.tasks if t.is_ready(self.completed_tasks)]
                for t in ready_tasks:
                    process = Process(target=t.process_function, args=(t.size, t.queue))
                    processes.append((t.id, process, t.queue))
                    process.start()
                    self.tasks.remove(t)

                # Avoid busy waiting if no tasks are ready
                if not ready_tasks:
                    time.sleep(0.1)

                # Update progress and check for completed tasks
                for task_id, process, queue in processes:
                    while not queue.empty():
                        progress_value = queue.get()
                        progress.update(task_progress_map[task_id], advance=1)
                        if progress_value >= self.get_task_size(task_id):  # Assuming task is completed when progress reaches size
                            self.completed_tasks.add(task_id)
                            progress.update(task_progress_map[task_id], completed=True)

                # Clean up completed processes
                processes = [(task_id, p, q) for task_id, p, q in processes if p.is_alive()]

    def get_task_size(self, task_id: int) -> int:
        for task in self.all_tasks:
            if task.id == task_id:
                return task.size
        return 0

def task_load_jsonl(size: int, queue: Queue) -> float:
    progress = 0
    for i in range(size):
        time.sleep(0.3)
        progress += 1
        queue.put(progress)
    return progress

def task_tokenize(size: int, queue: Queue) -> float:
    progress = 0
    for i in range(size):
        time.sleep(0.3)
        progress += 1
        queue.put(progress)
    return progress

if __name__ == "__main__":
    tasks = [
        Task(
            id=0,
            description="Load jsonl",
            size=10,
            progress_type=ProgressType.MIBI_PER_SECOND,
            process_function=task_load_jsonl,
        ),
        Task(
            id=1,
            description="Tokenize",
            size=20,
            progress_type=ProgressType.ITERATIONS_PER_SECOND,
            process_function=task_tokenize,
            dependencies=0,
        ),
    ]

    processor = TaskProcessor(command="RETRO Tokenizer", max_workers=4)
    processor.add_tasks(tasks)
    processor.process_tasks()

