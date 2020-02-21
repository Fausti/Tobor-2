package core;

import lime.utils.Int16Array;
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

	private var bufferVertices:GLBuffer;
	private var bufferIndices:GLBuffer;

	private var glMatrixUniform:GLUniformLocation;
	private var glProgram:GLProgram;
	private var glTexture:GLTexture;
	
	private var a_Position:Int;
	private var a_TexCoord:Int;
	private var a_Color:Int;
	
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
						
			"
			attribute vec4 a_Position;
			attribute vec2 a_TexCoord;
			attribute vec4 a_Color;
			
			varying vec2 v_TexCoord;
			varying vec4 v_Color;
						
			uniform mat4 u_Matrix;
						
			void main(void) {
							
				v_TexCoord = a_TexCoord;
				v_Color = a_Color;

				gl_Position = u_Matrix * a_Position;
							
			}";
					
		var fragmentSource = 
						
			#if !desktop
			"precision mediump float;" +
			#end
			"
			varying vec2 v_TexCoord;
			varying vec4 v_Color;

			uniform sampler2D u_Image0;
						
			void main(void)
			{
				gl_FragColor = texture2D (u_Image0, v_TexCoord) * v_Color;
			}";

			glProgram = GLProgram.fromSources (gl, vertexSource, fragmentSource);
			gl.useProgram (glProgram);
			
			a_Position = gl.getAttribLocation (glProgram, "a_Position");
			a_TexCoord = gl.getAttribLocation (glProgram, "a_TexCoord");
			a_Color = gl.getAttribLocation (glProgram, "a_Color");

			glMatrixUniform = gl.getUniformLocation (glProgram, "u_Matrix");
			var imageUniform = gl.getUniformLocation (glProgram, "u_Image0");
			
			gl.enableVertexAttribArray (a_Position);
			gl.enableVertexAttribArray (a_TexCoord);
			gl.enableVertexAttribArray (a_Color);
			
			gl.uniform1i (imageUniform, 0);
			
			gl.blendFunc (gl.SRC_ALPHA, gl.ONE_MINUS_SRC_ALPHA);
			gl.enable (gl.BLEND);
			
			// ARGB

			var data = [
				
				image.width, image.height, 0, 	1, 1,	1, 0, 0, 1,
				0, image.height, 0, 			0, 1,	1, 0, 0, 1,
				image.width, 0, 0, 				1, 0,	1, 0, 0, 1,
				0, 0, 0, 						0, 0,	1, 1, 1, 1
				
			];
			
			bufferVertices = gl.createBuffer();
			gl.bindBuffer (gl.ARRAY_BUFFER, bufferVertices);
			gl.bufferData (gl.ARRAY_BUFFER, new Float32Array (data), gl.STATIC_DRAW);
			gl.bindBuffer (gl.ARRAY_BUFFER, null);

			var indices = [
				0, 1, 2,
				2, 3, 1
			];

			bufferIndices = gl.createBuffer();
			gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, bufferIndices);
			gl.bufferData(gl.ELEMENT_ARRAY_BUFFER, new Int16Array(indices), gl.STATIC_DRAW);
			gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, null);
			
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
			
			gl.bindBuffer (gl.ARRAY_BUFFER, bufferVertices);
			gl.vertexAttribPointer (a_Position, 3, gl.FLOAT, false, 9 * Float32Array.BYTES_PER_ELEMENT, 0);
			gl.vertexAttribPointer (a_TexCoord, 2, gl.FLOAT, false, 9 * Float32Array.BYTES_PER_ELEMENT, 3 * Float32Array.BYTES_PER_ELEMENT);
			gl.vertexAttribPointer (a_Color, 	4, gl.FLOAT, false, 9 * Float32Array.BYTES_PER_ELEMENT, 5 * Float32Array.BYTES_PER_ELEMENT);

			gl.bindBuffer(gl.ELEMENT_ARRAY_BUFFER, bufferIndices);
			
			// gl.drawArrays (gl.TRIANGLE_STRIP, 0, 4);
			gl.drawElements(gl.TRIANGLES, 6, gl.UNSIGNED_SHORT, 0);
			
		}
	}

	public function resize(w:Int, h:Int) {
		this.width = w;
		this.height = h;
	}
}