#ifndef QTADDINONE_H
#define QTADDINONE_H

#include <QtWidgets/QMainWindow>
#include "ui_MainWnd.h" 

class MainWnd : public QMainWindow
{
	Q_OBJECT

public:
	MainWnd(QWidget *parent = 0);
	~MainWnd();

private slots:
	void on_btnOpenVsExpressDialog_clicked();

private:
	Ui::MainWnd ui;
};

#endif // QTADDINONE_H
