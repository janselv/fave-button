//
//  Easing.swift
//  FaveButton
//
// Copyright © 2016 Jansel Valentin.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
import UIKit


typealias Easing        = (_ t:CGFloat,_ b:CGFloat,_ c:CGFloat,_ d:CGFloat)-> CGFloat
typealias ElasticEasing = (_ t:CGFloat,_ b:CGFloat,_ c:CGFloat,_ d:CGFloat,_ a:CGFloat,_ p:CGFloat)-> CGFloat

// ELASTIC EASING

struct Elastic{
    static var EaseIn :Easing    = { (_t,b,c,d) -> CGFloat in
        var t = _t
        
        if t==0{ return b }
        t/=d
        if t==1{ return b+c }
        
        let p = d * 0.3
        let a = c
        let s = p/4
        
        t -= 1
        return -(a*pow(2,10*t) * sin( (t*d-s)*(2*(.pi))/p )) + b;
    }
    
    static var EaseOut :Easing   = { (_t,b,c,d) -> CGFloat in
        var t = _t
        
        if t==0{ return b }
        t/=d
        if t==1{ return b+c}
        
        let p = d * 0.3
        let a = c
        let s = p/4
        
        return (a*pow(2,-10*t) * sin( (t*d-s)*(2*(.pi))/p ) + c + b);
    }
    
    static var EaseInOut :Easing = { (_t,b,c,d) -> CGFloat in
        var t = _t
        if t==0{ return b}
        
        t = t/(d/2)
        if t==2{ return b+c }
        
        let p = d * (0.3*1.5)
        let a = c
        let s = p/4
        
        if t < 1 {
            t -= 1
            return -0.5*(a*pow(2,10*t) * sin((t*d-s)*(2*(.pi))/p )) + b;
        }
        t -= 1
        return a*pow(2,-10*t) * sin( (t*d-s)*(2*(.pi))/p )*0.5 + c + b;
    }
}


extension Elastic{
    static var ExtendedEaseIn :ElasticEasing    = { (_t,b,c,d,_a,_p) -> CGFloat in
        var t = _t
        var a = _a
        var p = _p
        var s:CGFloat = 0.0
        
        if t==0{ return b }
        
        t /= d
        if t==1{ return b+c }
        
        if a < abs(c) {
            a=c;  s = p/4
        }else {
            s = p/(2*(.pi)) * asin (c/a);
        }
        
        t -= 1
        return -(a*pow(2,10*t) * sin( (t*d-s)*(2*(.pi))/p )) + b;
    }
    
    
    static var ExtendedEaseOut :ElasticEasing    = { (_t,b,c,d,_a,_p) -> CGFloat in
        var s:CGFloat = 0.0
        var t = _t
        var a = _a
        var p = _p
        
        if t==0 { return b }
        
        t /= d
        if t==1 {return b+c}
        
        if a < abs(c) {
            a=c;  s = p/4;
        }else {
            s = p/(2*(.pi)) * asin (c/a)
        }
        return (a*pow(2,-10*t) * sin( (t*d-s)*(2*(.pi))/p ) + c + b)
    }
    
    
    static var ExtendedEaseInOut :ElasticEasing    = { (_t,b,c,d,_a,_p) -> CGFloat in
        var s:CGFloat = 0.0
        var t = _t
        var a = _a
        var p = _p
        
        if t==0{ return b }
        
        t /= d/2
        
        if t==2{ return b+c }
        
        if a < abs(c) {
            a=c; s=p/4;
        }else {
            s = p/(2*(.pi)) * asin (c/a)
        }
        
        if t < 1 {
            t -= 1
            return -0.5*(a*pow(2,10*t) * sin( (t*d-s)*(2*(.pi))/p )) + b;
        }
        t -= 1
        return a*pow(2,-10*t) * sin( (t*d-s)*(2*(.pi))/p )*0.5 + c + b;
    }
}


