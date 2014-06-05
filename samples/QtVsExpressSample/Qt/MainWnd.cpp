#include "MainWnd.h"

//#include "ExpressDialog.h"

MainWnd::MainWnd(QWidget *parent)
	: QMainWindow(parent)
{
	ui.setupUi(this);
}

MainWnd::~MainWnd()
{

}


void MainWnd::on_btnOpenVsExpressDialog_clicked()
{
	//auto dlg = new gui::qt::ExpressDialog(this);
	//dlg->setAttribute(Qt::WA_DeleteOnClose);
	//dlg->show();
}