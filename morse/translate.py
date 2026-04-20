"""Autogenerate codes for morse code module."""

from argparse import ArgumentParser, Namespace
from math import log2
import logging
from logging import Logger
import os

# follow generally accepted 1-3-7 timings
DOT_ON_TIME = 1
DASH_ON_TIME = 3
SYMBOL_GAP = 1
LETTER_GAP = 3
WORD_GAP = 7
# pause before repeating the message in a loop
END_MESSAGE_PAUSE_TIME = 12


def morse_code_to_timings(morse_code: str) -> list[int]:
    """Convert morse code to a list of wait times, in ticks."""
    words = morse_code.strip().split(' / ')
    timings = []
    for word in words:
        for symbol in word:
            # DOT
            if symbol == '.':
                timings.append(DOT_ON_TIME)
                timings.append(SYMBOL_GAP)
            # DASH
            elif symbol == '-':
                timings.append(DASH_ON_TIME)
                timings.append(SYMBOL_GAP)
            # LETTER SEPARATOR
            elif symbol == ' ':
                timings[-1] = LETTER_GAP
            else:
                raise ValueError(f"'{symbol}' is not a valid symbol in morse code.")
        timings[-1] = WORD_GAP
    timings[-1] = END_MESSAGE_PAUSE_TIME
    return timings


# Timings list structure:
# - list of ints representing number of ticks to wait
# - morse code module goes through the list, waiting and
#   then toggling its output
# - therefore each Morse code symbol is represented by
#   two consecutive timing numbers: on time and off time
# e.g. ".-"
#   -> [dot_on_time, dot_off_time, dash_on_time, dash_off_time]
# - pauses between letters and words are implemented by
#   adding to the off time of the last symbol

def list_to_verilog(
        values: list[int],
        list_name: str, 
        bits: int,
        indent_spaces: int) -> list[str]:
    """Convert list of integers to the Verilog code for that list.
    
    `list_name` must be a valid register name in Verilog.

    `bits` is the number of bits that should be used to represent each integer.
    
    This function returns a list of lines of Verilog code."""
    verilog_code = []
    indent = ' ' * indent_spaces
    for i, value in enumerate(values):
        if log2(value) >= bits:
            raise Warning(f"{bits} bits is not enough to represent {value}")
        verilog_code.append(f"{indent}{list_name}[{i}] = {bits}'d{value-1};")
    return verilog_code

def timings_to_verilog(timings_list, indent_spaces: int) -> list[str]:
    """Convert list of timing values to Verilog code.
    
    This function returns a list of lines of Verilog code."""
    return list_to_verilog(timings_list, list_name="timings", bits=4,
                           indent_spaces=indent_spaces)


def main(args: Namespace, log: Logger):
    """What this file does when run on the command line"""
    with open(args.filename) as file:
        morse_code = file.read().strip()
    log.info(f'Morse code: "{morse_code}"')

    timings = morse_code_to_timings(morse_code)
    log.info(f"Timings list: {timings}")

    output_filename = args.output_filename
    verilog_code = timings_to_verilog(timings, indent_spaces=args.indent_spaces)
    try:
        with open(output_filename, 'w') as file:
            file.write('\n'.join(verilog_code))
        log.info(f"Wrote Verilog code stub to '{output_filename}'")
    except OSError:
        log.error(f"Invalid filename, or folders on path do not exist: {output_filename}")


if __name__ == "__main__":
    
    log = logging.getLogger(os.path.basename(__file__))
    logging.basicConfig(level=logging.INFO)

    parser = ArgumentParser(description=__doc__)
    parser.add_argument("filename", help="File to convert from morse code to timings list")
    parser.add_argument("-o", "--output-filename",
                        type=str, default="translation_output.txt",
                        help="File name to write verilog array assignments to")
    parser.add_argument("-i", "--indent-spaces",
                        type=int, default=0,
                        help="Number of spaces to indent the verilog code by")
    args = parser.parse_args()

    main(args, log)
