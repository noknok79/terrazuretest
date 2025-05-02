import csv
import json
import os
import sys

def csv_to_json(csv_file_path):
    try:
        # Check if the file exists
        if not os.path.exists(csv_file_path):
            print(f"Error: The file '{csv_file_path}' does not exist.")
            return

        # Open the CSV file and read its contents
        with open(csv_file_path, mode='r', encoding='utf-8', errors='replace') as csv_file:
            csv_reader = csv.DictReader(csv_file)
            data = [row for row in csv_reader]

        # Generate the JSON file path
        json_file_path = os.path.splitext(csv_file_path)[0] + '.json'

        # Write the data to a JSON file
        with open(json_file_path, mode='w', encoding='utf-8') as json_file:
            json.dump(data, json_file, indent=4)

        print(f"JSON file created successfully: {json_file_path}")

    except Exception as e:
        print(f"An error occurred: {e}")

if __name__ == "__main__":
    # Check if the CSV file path is provided as a command-line argument
    if len(sys.argv) != 2:
        print("Usage: python csvtojson.py <csv_file_path>")
        sys.exit(1)

    # Get the CSV file path from the command-line arguments
    csv_file_path = sys.argv[1]
    csv_to_json(csv_file_path)