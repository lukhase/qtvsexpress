#include "TEMPLATE_DIALOG_NAME.h"
#include "ui_TEMPLATE_DIALOG_NAME.h"


namespace gui
{
	namespace qt
	{
		TEMPLATE_DIALOG_NAME::TEMPLATE_DIALOG_NAME(QWidget *parent) :
			QDialog(parent),
			ui_(std::make_unique<Ui::TEMPLATE_DIALOG_NAME>())
		{
			ui_->setupUi(this);
		}
	}
}