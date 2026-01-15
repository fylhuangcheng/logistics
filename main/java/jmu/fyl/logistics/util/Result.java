package jmu.fyl.logistics.util;

import java.io.Serializable;


public class Result<T> implements Serializable {
    private static final long serialVersionUID = 1L;

    private int code;
    private String message;
    private T data;
    private String redirect;

    public Result() {}

    public Result(int code, String message) {
        this.code = code;
        this.message = message;
    }

    public Result(int code, String message, T data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }

    public Result(int code, String message, T data, String redirect) {
        this.code = code;
        this.message = message;
        this.data = data;
        this.redirect = redirect;
    }

    public static <T> Result<T> success() {
        return new Result<>(200, "操作成功");
    }

    public static <T> Result<T> success(String message) {
        return new Result<>(200, message, null);
    }

    public static <T> Result<T> success(T data) {
        return new Result<>(200, "操作成功", data);
    }

    public static <T> Result<T> success(String message, T data) {
        return new Result<>(200, message, data);
    }

    public static <T> Result<T> success(String message, T data, String redirect) {
        return new Result<>(200, message, data, redirect);
    }

    public static <T> Result<T> error(int code, String message) {
        return new Result<>(code, message);
    }

    public static <T> Result<T> error(String message) {
        return new Result<>(500, message);
    }

    public static <T> Result<T> error(int code, String message, T data) {
        return new Result<>(code, message, data);
    }

    public static <T> Result<T> unauthorized() {
        return new Result<>(401, "未授权访问");
    }

    public static <T> Result<T> forbidden() {
        return new Result<>(403, "禁止访问");
    }

    public static <T> Result<T> notFound() {
        return new Result<>(404, "资源不存在");
    }

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public T getData() {
        return data;
    }

    public void setData(T data) {
        this.data = data;
    }

    public String getRedirect() {
        return redirect;
    }

    public void setRedirect(String redirect) {
        this.redirect = redirect;
    }
}