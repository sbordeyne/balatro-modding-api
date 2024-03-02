from zipfile import ZipFile
import luaparser.ast
import tempfile
from pathlib import Path
import shutil

def patch_main_file(filename: str):
    tree = None
    with open(filename, "r") as file:
        source = file.read()
        tree = luaparser.ast.parse(source)
        require_statement = luaparser.ast.Call(
            func=luaparser.ast.Name("require"),
            args=[luaparser.ast.String("modloader", delimiter=luaparser.ast.StringDelimiter.DOUBLE_QUOTE)]
        )
        existing_requires = [
            node
            for node in tree.body.body
            if isinstance(node, luaparser.ast.Call) and
               isinstance(node.func, luaparser.ast.Name) and
               node.func.id == "require"
        ]

        index = tree.body.body.index(existing_requires[-1]) + 1
        tree.body.body.insert(index, require_statement)
        
    with open(filename, "w") as file:
        file.write(luaparser.ast.to_lua_source(tree))


def get_path_to_balatro() -> Path:
    ...


def main():
    path_to_balatro = get_path_to_balatro()
    with tempfile.TemporaryDirectory() as tempdir:
        with ZipFile("Balatro.exe", "r") as archive:
            archive.extractall(tempdir)
        temppath = Path(tempdir)
        for filename in temppath.rglob("*.lua"):
            if "main" in filename.name:
                patch_main_file(filename)
        shutil.copyfile("patcher/modloader.lua", temppath / "modloader.lua")
        with ZipFile("Balatro-patched.exe", "w") as archive:
            for filename in temppath.rglob("*"):
                archive.write(filename, filename.relative_to(temppath))

    archive = ZipFile("Balatro-patched.exe", "r")
    archive.extractall("result")
    archive.close()


if __name__ == "__main__":
    main()
