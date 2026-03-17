#!/usr/bin/env python3
"""
Format phone numbers to E.164 standard for WhatsApp.
Usage: python3 format_number.py <phone_number>
"""
import sys
import re

def format_e164(phone):
    # Remove all non-numeric characters
    digits = re.sub(r'\D', '', phone)
    
    # If doesn't start with +, add it
    if not phone.startswith('+'):
        # Assume Brazil if starts with 55
        if digits.startswith('55'):
            return f"+{digits}"
        else:
            # Default to Brazil (+55)
            return f"+55{digits}"
    else:
        return f"+{digits}"

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 format_number.py <phone_number>")
        print("Example: python3 format_number.py '84 92162-9373'")
        sys.exit(1)
    
    number = sys.argv[1]
    formatted = format_e164(number)
    print(formatted)
