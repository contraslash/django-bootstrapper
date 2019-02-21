import shutil
import os
import pytest

from django_bootstrapper import django_bootstrapper


@pytest.fixture(scope="module", autouse=True)
def clean_up_repos():
    print("Executing cleaning repos")
    if os.path.exists("test_project"):
        shutil.rmtree("test_project")
    if os.path.exists("test_project_no_submodules"):
        shutil.rmtree("test_project_no_submodules")

def test_check_submodule():
    bootstrapper = django_bootstrapper.DjangoBootstrapper()
    bootstrapper.create_directory("test_project")

    bootstrapper.initialize_git_repo(
        "test_project",
        "test_project",
        bootstrapper.OPTION_DICT[django_bootstrapper.TEMPLATE_SUBMODULE_NAME_KEY],
        use_submodules=True
    )
    assert len(bootstrapper.repository.submodules) == 3
    shutil.rmtree("test_project")


def test_check_creating_without_submodule():
    bootstrapper = django_bootstrapper.DjangoBootstrapper()

    bootstrapper.repository = None
    bootstrapper.create_directory("test_project_no_submodules")
    bootstrapper.initialize_git_repo(
        "test_project_no_submodules",
        "test_project_no_submodules",
        bootstrapper.OPTION_DICT[django_bootstrapper.TEMPLATE_SUBMODULE_NAME_KEY],
        use_submodules=False
    )

    assert len(bootstrapper.repository.submodules) == 0

    shutil.rmtree("test_project_no_submodules")
