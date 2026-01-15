
/**
 * 物流管理系统工具函数
 */

const Utils = {

    /**
     * 格式化日期
     * @param {Date|string} date 日期对象或字符串
     * @param {string} format 格式，默认 'YYYY-MM-DD HH:mm:ss'
     * @returns {string} 格式化后的日期字符串
     */
    formatDate: function(date, format = 'YYYY-MM-DD HH:mm:ss') {
        if (!date) return '';

        const d = date instanceof Date ? date : new Date(date);

        // 检查日期是否有效
        if (isNaN(d.getTime())) return '';

        const year = d.getFullYear();
        const month = String(d.getMonth() + 1).padStart(2, '0');
        const day = String(d.getDate()).padStart(2, '0');
        const hours = String(d.getHours()).padStart(2, '0');
        const minutes = String(d.getMinutes()).padStart(2, '0');
        const seconds = String(d.getSeconds()).padStart(2, '0');

        return format
            .replace('YYYY', year)
            .replace('MM', month)
            .replace('DD', day)
            .replace('HH', hours)
            .replace('mm', minutes)
            .replace('ss', seconds);
    },

    /**
     * 格式化数字（保留小数）
     * @param {number} num 数字
     * @param {number} decimals 小数位数，默认2
     * @returns {string} 格式化后的数字字符串
     */
    formatNumber: function(num, decimals = 2) {
        if (num === null || num === undefined || isNaN(num)) {
            return decimals === 0 ? '0' : '0.' + '0'.repeat(decimals);
        }

        const n = parseFloat(num);
        return n.toFixed(decimals);
    },

    /**
     * 显示成功消息
     * @param {string} message 消息内容
     */
    showSuccess: function(message) {
        this.showToast('success', message);
    },

    /**
     * 显示错误消息
     * @param {string} message 消息内容
     */
    showError: function(message) {
        this.showToast('error', message);
    },

    /**
     * 显示警告消息
     * @param {string} message 消息内容
     */
    showWarning: function(message) {
        this.showToast('warning', message);
    },

    /**
     * 显示信息消息
     * @param {string} message 消息内容
     */
    showInfo: function(message) {
        this.showToast('info', message);
    },

    /**
     * 显示Toast消息
     * @param {string} type 消息类型
     * @param {string} message 消息内容
     */
    showToast: function(type, message) {
        // 创建或获取toast容器
        let toastContainer = document.querySelector('.toast-container');
        if (!toastContainer) {
            toastContainer = document.createElement('div');
            toastContainer.className = 'toast-container position-fixed bottom-0 end-0 p-3';
            document.body.appendChild(toastContainer);
        }

        // 创建toast元素
        const toastId = 'toast-' + Date.now();
        const toastEl = document.createElement('div');
        toastEl.id = toastId;
        toastEl.className = 'toast';
        toastEl.setAttribute('role', 'alert');
        toastEl.setAttribute('aria-live', 'assertive');
        toastEl.setAttribute('aria-atomic', 'true');

        // 设置样式
        const bgClass = {
            'success': 'bg-success text-white',
            'error': 'bg-danger text-white',
            'warning': 'bg-warning text-dark',
            'info': 'bg-info text-white'
        }[type] || 'bg-primary text-white';

        toastEl.innerHTML = `
            <div class="toast-header ${bgClass}">
                <strong class="me-auto">${this.getToastTitle(type)}</strong>
                <button type="button" class="btn-close btn-close-white" data-bs-dismiss="toast"></button>
            </div>
            <div class="toast-body">
                ${message}
            </div>
        `;

        toastContainer.appendChild(toastEl);

        // 显示toast
        const toast = new bootstrap.Toast(toastEl, { delay: 3000 });
        toast.show();

        // 自动移除
        toastEl.addEventListener('hidden.bs.toast', function () {
            toastEl.remove();
        });
    },

    /**
     * 获取Toast标题
     * @param {string} type 消息类型
     * @returns {string} 标题
     */
    getToastTitle: function(type) {
        const titles = {
            'success': '操作成功',
            'error': '操作失败',
            'warning': '警告',
            'info': '提示'
        };
        return titles[type] || '系统提示';
    },

    /**
     * 确认对话框
     * @param {string} message 确认消息
     * @param {Function} callback 确认回调函数
     * @param {string} title 对话框标题
     */
    confirm: function(message, callback, title = '确认操作') {
        if (window.confirm(message)) {
            callback && callback();
        }
    },

    /**
     * 加载数据
     * @param {string} url 请求URL
     * @param {Object} params 请求参数
     * @param {Function} callback 成功回调
     * @param {Function} errorCallback 错误回调
     */
    loadData: function(url, params = {}, callback, errorCallback) {
        Utils.showLoading();

        $.ajax({
            url: url,
            type: 'GET',
            data: params,
            dataType: 'json',
            success: function(response) {
                Utils.hideLoading();
                if (response.code === 200) {
                    callback && callback(response.data);
                } else {
                    Utils.showError(response.message || '加载数据失败');
                    errorCallback && errorCallback(response);
                }
            },
            error: function(xhr) {
                Utils.hideLoading();
                Utils.showError('请求失败: ' + (xhr.statusText || '网络错误'));
                errorCallback && errorCallback(xhr);
            }
        });
    },

    /**
     * 提交表单数据
     * @param {string} url 请求URL
     * @param {Object} data 表单数据
     * @param {string} method 请求方法，默认POST
     * @param {Function} callback 成功回调
     * @param {Function} errorCallback 错误回调
     */
    submitForm: function(url, data, method = 'POST', callback, errorCallback) {
        Utils.showLoading();

        $.ajax({
            url: url,
            type: method,
            contentType: 'application/json',
            data: JSON.stringify(data),
            dataType: 'json',
            success: function(response) {
                Utils.hideLoading();
                if (response.code === 200) {
                    Utils.showSuccess(response.message || '操作成功');
                    callback && callback(response.data);
                } else {
                    Utils.showError(response.message || '操作失败');
                    errorCallback && errorCallback(response);
                }
            },
            error: function(xhr) {
                Utils.hideLoading();
                Utils.showError('请求失败: ' + (xhr.statusText || '网络错误'));
                errorCallback && errorCallback(xhr);
            }
        });
    },

    /**
     * 删除数据
     * @param {string} url 请求URL
     * @param {Function} callback 成功回调
     * @param {string} confirmMessage 确认消息
     */
    deleteData: function(url, callback, confirmMessage = '确定要删除吗？此操作不可恢复！') {
        Utils.confirm(confirmMessage, function() {
            Utils.showLoading();

            $.ajax({
                url: url,
                type: 'DELETE',
                dataType: 'json',
                success: function(response) {
                    Utils.hideLoading();
                    if (response.code === 200) {
                        Utils.showSuccess(response.message || '删除成功');
                        callback && callback();
                    } else {
                        Utils.showError(response.message || '删除失败');
                    }
                },
                error: function(xhr) {
                    Utils.hideLoading();
                    Utils.showError('请求失败: ' + (xhr.statusText || '网络错误'));
                }
            });
        });
    },

    /**
     * 获取订单状态标签
     * @param {number} status 状态码
     * @returns {Object} 包含label和class的对象
     */
    getOrderStatusLabel: function(status) {
        const statusMap = {
            1: { label: '已下单', class: 'badge bg-secondary' },
            2: { label: '已揽收', class: 'badge bg-info' },
            3: { label: '运输中', class: 'badge bg-warning' },
            4: { label: '已到达', class: 'badge bg-success' },
            5: { label: '已签收', class: 'badge bg-primary' }
        };
        return statusMap[status] || { label: '未知状态', class: 'badge bg-dark' };
    },

    /**
     * 获取车辆状态标签
     * @param {number} status 状态码
     * @returns {Object} 包含label和class的对象
     */
    getVehicleStatusLabel: function(status) {
        const statusMap = {
            1: { label: '空闲', class: 'badge bg-success' },
            2: { label: '运输中', class: 'badge bg-warning' },
            3: { label: '维修中', class: 'badge bg-danger' }
        };
        return statusMap[status] || { label: '未知状态', class: 'badge bg-dark' };
    },

    /**
     * 获取用户类型标签
     * @param {number} type 用户类型
     * @returns {Object} 包含label和class的对象
     */
    getUserTypeLabel: function(type) {
        const typeMap = {
            1: { label: '管理员', class: 'badge bg-danger' },
            2: { label: '司机', class: 'badge bg-primary' },
            3: { label: '客户', class: 'badge bg-success' }
        };
        return typeMap[type] || { label: '未知类型', class: 'badge bg-dark' };
    },

    /**
     * 获取网点状态标签
     * @param {number} status 状态码
     * @returns {Object} 包含label和class的对象
     */
    getStationStatusLabel: function(status) {
        const statusMap = {
            1: { label: '启用', class: 'badge bg-success' },
            0: { label: '停用', class: 'badge bg-danger' }
        };
        return statusMap[status] || { label: '未知状态', class: 'badge bg-dark' };
    },

    /**
     * 显示加载遮罩
     */
    showLoading: function() {
        const overlay = document.getElementById('loadingOverlay');
        if (overlay) {
            overlay.classList.remove('d-none');
        }
    },

    /**
     * 隐藏加载遮罩
     */
    hideLoading: function() {
        const overlay = document.getElementById('loadingOverlay');
        if (overlay) {
            overlay.classList.add('d-none');
        }
    },

    /**
     * 验证表单
     * @param {HTMLElement} form 表单元素
     * @returns {boolean} 是否验证通过
     */
    validateForm: function(form) {
        if (!form.checkValidity()) {
            form.classList.add('was-validated');
            return false;
        }
        return true;
    },

    /**
     * 深拷贝对象
     * @param {Object} obj 要拷贝的对象
     * @returns {Object} 拷贝后的对象
     */
    deepClone: function(obj) {
        return JSON.parse(JSON.stringify(obj));
    },

    /**
     * 防抖函数
     * @param {Function} func 要执行的函数
     * @param {number} wait 等待时间（毫秒）
     * @returns {Function} 防抖后的函数
     */
    debounce: function(func, wait) {
        if (typeof func !== 'function') {
            console.error('debounce: func must be a function');
            return function() {};
        }

        let timeout;
        return function executedFunction(...args) {
            const context = this;
            const later = function() {
                timeout = null;
                try {
                    func.apply(context, args);
                } catch (error) {
                    console.error('Error in debounced function:', error);
                }
            };

            clearTimeout(timeout);
            timeout = setTimeout(later, wait);
        };
    },

    /**
     * 节流函数
     * @param {Function} func 要执行的函数
     * @param {number} limit 限制时间（毫秒）
     * @returns {Function} 节流后的函数
     */
    throttle: function(func, limit) {
        let inThrottle;
        return function(...args) {
            if (!inThrottle) {
                func.apply(this, args);
                inThrottle = true;
                setTimeout(() => inThrottle = false, limit);
            }
        };
    },

    /**
     * 生成随机字符串
     * @param {number} length 字符串长度
     * @returns {string} 随机字符串
     */
    randomString: function(length = 8) {
        const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        let result = '';
        for (let i = 0; i < length; i++) {
            result += chars.charAt(Math.floor(Math.random() * chars.length));
        }
        return result;
    },

    /**
     * 格式化文件大小
     * @param {number} bytes 字节数
     * @returns {string} 格式化后的文件大小
     */
    formatFileSize: function(bytes) {
        if (bytes === 0) return '0 Bytes';
        const k = 1024;
        const sizes = ['Bytes', 'KB', 'MB', 'GB'];
        const i = Math.floor(Math.log(bytes) / Math.log(k));
        return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + ' ' + sizes[i];
    },

    /**
     * 检查是否是有效的URL
     * @param {string} url URL字符串
     * @returns {boolean} 是否是有效的URL
     */
    isValidUrl: function(url) {
        try {
            new URL(url);
            return true;
        } catch (_) {
            return false;
        }
    },

    /**
     * 获取URL参数
     * @param {string} name 参数名
     * @returns {string|null} 参数值
     */
    getUrlParam: function(name) {
        const urlParams = new URLSearchParams(window.location.search);
        return urlParams.get(name);
    },

    /**
     * 设置URL参数
     * @param {string} name 参数名
     * @param {string} value 参数值
     */
    setUrlParam: function(name, value) {
        const urlParams = new URLSearchParams(window.location.search);
        urlParams.set(name, value);
        window.history.replaceState({}, '', `${window.location.pathname}?${urlParams.toString()}`);
    },

    /**
     * 移除URL参数
     * @param {string} name 参数名
     */
    removeUrlParam: function(name) {
        const urlParams = new URLSearchParams(window.location.search);
        urlParams.delete(name);
        window.history.replaceState({}, '', `${window.location.pathname}?${urlParams.toString()}`);
    }
};

// 全局导出
window.Utils = Utils;