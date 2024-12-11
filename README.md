# deleteOldFiles.sh

`deleteOldFiles.sh` is a Bash script designed to manage and clean up old files in a specified directory. It moves files older than a specified number of days to an "old" subdirectory and deletes files from the "old" subdirectory that are older than the specified number of days.

## Usage

```sh
./deleteOldFiles.sh <dirPath> <daysInterval>
```

- `<dirPath>`: The path to the directory to be cleaned.
- `<daysInterval>`: The number of days to determine which files are considered old.

## Example

```sh
./deleteOldFiles.sh /path/to/directory 30
```

This command will move files older than 30 days from `/path/to/directory` to `/path/to/directory/old` and delete files older than 30 days from the "old" subdirectory.

## Cron Job

To automate the script using a cron job, you can add the following line to your crontab file:

```sh
0 0 * * * /path/to/deleteOldFiles.sh /path/to/directory 30
```

This cron job will run the script every day at midnight to clean up the specified directory.

## Logging

The script uses a simple logging function to output messages with timestamps. The log messages include information about the actions being performed, such as creating directories, moving files, and deleting files.

## Error Handling

The script includes error handling to ensure that it exits gracefully in case of errors, such as:

- The specified directory does not exist.
- The `daysInterval` is not a valid number.
- Failure to create or move files.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.