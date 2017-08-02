require('UIView, UIColor, UILabel')
defineClass('AppDelegate', {
            // replace the -genView method
            genView: function() {
            var view = self.ORIGgenView();
            view.setBackgroundColor(UIColor.greenColor())
            var label = UILabel.alloc().initWithFrame(view.frame());
            label.setText("JSPatch");
            label.setTextAlignment(1);
            view.addSubview(label);
            return view;
            },
            
            //oc 调用 js， add new function
            testView: function()
            {
//            self.ORIGtestView();

            var data = self.window();
            console.log(data);
            
            
            
            console.log(1231231);
            //            var view = self.ORIGgenView();
            //            var view = UIView.alloc().init();
            //            var red = UIColor.redColor();
            //            view.setBackgroundColor(red);
            },

            
            });

//是否覆盖原方法
defineClass('FNMainVC',{
            
            viewDidLoad: function()
            {
            console.log("hello 9-09-09-09-09");

            self.ORIGviewDidLoad();
            console.log("hello world");
            }
            
            });

