poker-test
==========

Compare several pairs of poker hands and to indicate which, if either, has a higher rank.

=== Usage
  ruby app.rb

=== Example output
  ➜  poker-test git:(master) ✗ ruby app.rb
  "[*] Game's hand Number #1"
  "Player #0: AH QC 4D 7C 6H"
  "Player #1: 2D 6S 3D JD 10S"
  "[+] Player #0 wins - High card"
  "[*] Game's hand Number #2"
  "Player #0: 9D 6C 9D 6S 2D"
  "Player #1: 3H 4D 4D JD 8D"
  "[+] Player #0 wins - Two pairs"
  "[*] Game's hand Number #3"
  "Player #0: QD 7H 9D QC KD"
  "Player #1: 9D 4S KH 3H 6C"
  "[+] Player #0 wins - Pair"
  "[*] Game's hand Number #4"
  "Player #0: 8C 7S 10S 8S 6H"
  "Player #1: JC 2D KC KC KH"
  "[+] Player #1 wins - Three of a kind"
  "[*] Game's hand Number #5"
  "Player #0: 4C 8H AC 4C 6H"
  "Player #1: JH 2D 8D 3H 6S"
  "[+] Player #0 wins - Pair"

=== TODO
Write some specs
