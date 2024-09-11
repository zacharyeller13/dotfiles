def parse_lines(lines: list[str]) -> list[float]:
    """Parse each line into a list of floats

    Args:
        `lines` (str): A multi-line string in the format like:

            | 2024-04-29 | <client_name> | .10   | Email catchup |

    Returns:
        list[float]: All the hours/partial hours of the day
    """
    nums = [float(line.split("|")[3].strip()) for line in lines]

    return nums


if __name__ == "__main__":
    lines = []
    print("Input all lines for the day (press enter twice to continue):  ")
    while True:
        try:
            line = input("")
        except EOFError:
            break
        if line == "":
            break
        lines.append(line)

    print(sum(parse_lines(lines)))
