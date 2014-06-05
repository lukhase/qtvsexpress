#pragma once

#include <memory>

#include <QtWidgets/QDialog>

namespace Ui
{
	class TEMPLATE_DIALOG_NAME;
}

namespace gui
{
	namespace qt
	{
		class TEMPLATE_DIALOG_NAME : public QDialog
		{
			Q_OBJECT 
			
		public:
			explicit TEMPLATE_DIALOG_NAME(QWidget *parent = nullptr);

		private:
			std::unique_ptr<Ui::TEMPLATE_DIALOG_NAME> ui_;
		};
	}
}


