#include <ncurses/ncurses.h>

int main()
{
  int ch;

  initscr();
  raw(); // Turns off line buffering
  keypad(stdscr, TRUE); // Enables strange keys
  noecho(); //don't echo the characters typed

  printw("Type a character to see it boldened");
  ch = getch(); // If raw hadn't been called, we'd have to press enter before it gets to the program

  if(ch == KEY_F(1)) // withoutkeybad we wouldn't ever see this
    printw("F1 key pressed"); //Without Noecho this would look ugly and strange
  else
  {
    printw("The pressed ket is: ");
    attron(A_BOLD);
    printw("%c", ch);
    attroff(A_BOLD);
  }

  refresh();
  getch();
  endwin();

 return 0;
}
