package core;

import lime.math.Matrix4;
import lime.graphics.opengl.GLTexture;
import lime.graphics.opengl.GLUniformLocation;
import lime.graphics.opengl.GLBuffer;
import lime.utils.Float32Array;
import lime.graphics.opengl.GLProgram;
import lime.graphics.Image;
import lime.utils.Assets;
import lime.graphics.WebGLRenderContext;
import sys.io.File;

class WebGLRenderer {
	var gl:WebGLRenderContext;

	private var glBuffer:GLBuffer;
	private var glMatrixUniform:GLUniformLocation;
	private var glProgram:GLProgram;
	private var glTexture:GLTexture;
	private var glTextureAttribute:Int;
	private var glVertexAttribute:Int;
	
	var image:Image;

	var width:Int;
	var height:Int;

	public function new(gl:WebGLRenderContext, width:Int, height:Int) {
		this.gl = gl;
		this.width = width;
		this.height = height;

		/*
		var fin = File.read("Assets/lime.png", true);
		var content = fin.readAll();
		fin.close();
		*/

		image = Assets.getImage ("assets/lime.png");
					
		var vertexSource = 
						
			"attribute vec4 aPosition;
			attribute vec2 aTexCoord;
			varying vec2 vTexCoord;
						
			uniform mat4 uMatrix;
						
			void main(void) {
							
				vTexCoord = aTexCoord;
				gl_Position = uMatrix * aPosition;
							
			}";
					
		var fragmentSource = 
						
			#if !desktop
			"precision mediump float;" +
			#end
			"varying vec2 vTexCoord;
			uniform sampler2D uImage0;
						
			void main(void)
			{
				gl_FragColor = texture2D (uImage0, vTexCoord);
			}";

			glProgram = GLProgram.fromSources (gl, vertexSource, fragmentSource);
			gl.useProgram (glProgram);
			
			glVertexAttribute = gl.getAttribLocation (glProgram, "aPosition");
			glTextureAttribute = gl.getAttribLocation (glProgram, "aTexCoord");
			glMatrixUniform = gl.getUniformLocation (glProgram, "uMatrix");
			var imageUniform = gl.getUniformLocation (glProgram, "uImage0");
			
			gl.enableVertexAttribArray (glVertexAttribute);
			gl.enableVertexAttribArray (glTextureAttribute);
			gl.uniform1i (imageUniform, 0);
			
			gl.blendFunc (gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
			gl.enable (gl.BLEND);
			
			var data = [
				
				image.width, image.height, 0, 1, 1,
				0, image.height, 0, 0, 1,
				image.width, 0, 0, 1, 0,
				0, 0, 0, 0, 0
				
			];
			
			glBuffer = gl.createBuffer ();
			gl.bindBuffer (gl.ARRAY_BUFFER, glBuffer);
			gl.bufferData (gl.ARRAY_BUFFER, new Float32Array (data), gl.STATIC_DRAW);
			gl.bindBuffer (gl.ARRAY_BUFFER, null);
			
			glTexture = gl.createTexture ();
			gl.bindTexture (gl.TEXTURE_2D, glTexture);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_S, gl.CLAMP_TO_EDGE);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_WRAP_T, gl.CLAMP_TO_EDGE);
			
			gl.texImage2D (gl.TEXTURE_2D, 0, gl.RGBA, image.buffer.width, image.buffer.height, 0, gl.RGBA, gl.UNSIGNED_BYTE, image.data);
			
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MAG_FILTER, gl.LINEAR);
			gl.texParameteri (gl.TEXTURE_2D, gl.TEXTURE_MIN_FILTER, gl.LINEAR);
			gl.bindTexture (gl.TEXTURE_2D, null);
	}

	public function render() {
		gl.viewport (0, 0, width, height);
		
		gl.clearColor (0, 0, 0, 1);
		gl.clear (gl.COLOR_BUFFER_BIT);
		
		if (image != null) {
			
			var matrix = new Matrix4 ();
			matrix.createOrtho (0, width, height, 0, -1000, 1000);
			gl.uniformMatrix4fv (glMatrixUniform, false, matrix);
			
			gl.activeTexture (gl.TEXTURE0);
			gl.bindTexture (gl.TEXTURE_2D, glTexture);
			
			#if desktop
			gl.enable (gl.TEXTURE_2D);
			#end
			
			gl.bindBuffer (gl.ARRAY_BUFFER, glBuffer);
			gl.vertexAttribPointer (glVertexAttribute, 3, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 0);
			gl.vertexAttribPointer (glTextureAttribute, 2, gl.FLOAT, false, 5 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
			
			gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
			
		}
	}

	public function resize(w:Int, h:Int) {
		this.width = w;
		this.height = h;
	}
}