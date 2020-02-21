package core;

import lime.graphics.RenderContext;
import lime.app.Application;
import lime.utils.Log;

class LimeApplication extends Application {
	private var renderer:core.WebGLRenderer;

	public function new() {
		super();
	}

	override function onWindowCreate() {
		switch(window.context.type) {
			case OPENGL, OPENGLES, WEBGL:
				var gl = window.context.webgl;
				renderer = new WebGLRenderer(gl, window.width, window.height);

				init();
			default:	
				Log.warn ("Current render context not supported");
		}
	}

	override function render(context:RenderContext) {
		switch (context.type) {
			case OPENGL, OPENGLES, WEBGL:
				var gl = context.webgl;
				if (renderer != null) {
					renderer.resize(window.width, window.height);
					renderer.render();
				}
			default:
		}
	}

	public function init() {

	}

	public function setWindowTitle(t:String) {
		window.title = t;
	}
}