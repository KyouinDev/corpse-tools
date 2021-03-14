# corpse_tools

A tool to extract/replace text in a readable way for Corpse Party .BIN files.

## How to use

`extract-text -i <file-path>` \
Extract text from the given file. A .BIN file must be provided.

`replace-text -o <file-path> -m <file-path>` \
Replace text of the original file with modified file. \
Obviously, the first parameter refers to the original .BIN file, while the second one to your modified .txt file.

Before replacing the text, a comparison check will be ran. This will checks if any lines were changed, or if there are
some errors.

## Latest changelog

### 0.1.0

- Initial version, bop