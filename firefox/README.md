# Configuration files for Firefox

## Adding my custom CSS for Firefox

Within the directory ~/.mozilla/firefox/(somecharacters).default,
create a directory called "chrome".
Softlink ./chrome/userChrome.css to that location.

Finally, I recommend soft-linking the aforementioned directory
to ~/firefox-profile
