#include <ncurses/ncurses.h>

int main()
{
  initscr();
  printw("Hello World!");
  refresh();
  getch();
  getch();
  getch();
  endwin();

  return 0;

}
