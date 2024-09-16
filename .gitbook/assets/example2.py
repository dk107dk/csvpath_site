from csvpath import CsvPath

csvpath = """$trivial.csv[*][
            ~ Apply three rules to check if a CSV file meets expectations ~
            yes()
          ]"""

path = CsvPath()
path.parse(csvpath)
path.fast_forward()

print("Is this file valid?")
if path.is_valid:
    print("Yes! All good.")
else:
    print("No. Something is wrong with it.")

