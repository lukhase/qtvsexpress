#include <QtWidgets/QApplication>
#include "Qt/MainWnd.h"

int main(int argc, char *argv[])
{
	QApplication a(argc, argv);
	MainWnd w;
	w.show();
	return a.exec();
}
