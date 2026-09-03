#include <ncurses/ncurses.h>
#include <string.h>


int main()
{
  char mesg[]="Just a tring";
  int row,col;
  char c = '0';

  initscr();
  raw();

  while(c != 'q')
  {
    getmaxyx(stdscr,row,col); // get the size of the window
    mvprintw(row/2,(col-strlen(mesg))/2, "%s", mesg); //print in the middle of our screen

    mvprintw(row-2,0,"This screen has %d rows and %d colomns\n", row, col);

    printw("Try resizing your window and re-run. q to quit");
    refresh();

    c = getch();
  }

  endwin();

  return 0;
}
