/**
 * 物流管理系统主JavaScript文件
 */

$(document).ready(function() {
    // 初始化工具提示
    $('[data-bs-toggle="tooltip"]').tooltip();

    // 初始化弹出框
    $('[data-bs-toggle="popover"]').popover();

    // 自动隐藏提示消息
    $('.alert-auto-dismiss').delay(3000).fadeOut('slow');

    // 表单提交处理
    $('.ajax-form').on('submit', function(e) {
        e.preventDefault();

        const form = $(this);
        const url = form.attr('action');
        const method = form.attr('method') || 'POST';

        // 验证表单
        if (!Utils.validateForm(form[0])) {
            return;
        }

        // 收集表单数据
        const formData = {};
        form.serializeArray().forEach(item => {
            formData[item.name] = item.value;
        });

        Utils.submitForm(url, formData, method, function(data) {
            // 如果有重定向URL，则跳转
            if (data && data.redirect) {
                setTimeout(() => {
                    window.location.href = data.redirect;
                }, 1500);
            }
            // 如果表单有回调函数，执行回调
            else if (form.data('callback')) {
                const callback = form.data('callback');
                if (callback === 'reload') {
                    setTimeout(() => window.location.reload(), 1500);
                } else if (callback === 'back') {
                    setTimeout(() => window.history.back(), 1500);
                } else if (typeof window[callback] === 'function') {
                    window[callback](data);
                }
            }
        });
    });

    // 删除按钮点击事件
    $(document).on('click', '.btn-delete', function(e) {
        e.preventDefault();
        const url = $(this).attr('href') || $(this).data('url');
        const callback = $(this).data('callback');

        Utils.deleteData(url, function() {
            if (callback === 'reload') {
                window.location.reload();
            } else if (callback === 'back') {
                window.history.back();
            } else if (callback && typeof window[callback] === 'function') {
                window[callback]();
            }
        });
    });

    // 状态切换按钮
    $(document).on('click', '.btn-toggle-status', function() {
        const url = $(this).data('url');
        const newStatus = $(this).data('status');
        const btn = $(this);

        Utils.submitForm(url, { status: newStatus }, 'PUT', function() {
            btn.closest('tr').find('.status-badge').text(newStatus === 1 ? '启用' : '停用')
                .toggleClass('bg-success bg-danger');
        });
    });

    // 搜索表单处理
    $('.search-form').on('submit', function(e) {
        e.preventDefault();
        const form = $(this);
        const params = form.serialize();
        const url = window.location.pathname + '?' + params;
        window.location.href = url;
    });

    // 重置搜索
    $('.btn-reset').on('click', function() {
        window.location.href = window.location.pathname;
    });

    // 分页处理
    $(document).on('click', '.page-link', function(e) {
        e.preventDefault();
        const url = $(this).attr('href');
        if (url) {
            window.location.href = url;
        }
    });

    // 表格排序
    $('.sortable').on('click', function() {
        const field = $(this).data('field');
        const currentOrder = $(this).data('order') || 'asc';
        const newOrder = currentOrder === 'asc' ? 'desc' : 'asc';

        // 更新URL参数
        const urlParams = new URLSearchParams(window.location.search);
        urlParams.set('sortField', field);
        urlParams.set('sortOrder', newOrder);

        window.location.href = window.location.pathname + '?' + urlParams.toString();
    });

    // 模态框显示事件
    $('.modal').on('shown.bs.modal', function () {
        $(this).find('input:first').focus();
    });

    // 输入框自动聚焦
    $('.autofocus').focus();

    // 数字输入框限制
    $('input[type="number"]').on('input', function() {
        const min = parseFloat($(this).attr('min')) || -Infinity;
        const max = parseFloat($(this).attr('max')) || Infinity;
        let value = parseFloat($(this).val());

        if (isNaN(value)) {
            value = min > -Infinity ? min : 0;
        } else if (value < min) {
            value = min;
        } else if (value > max) {
            value = max;
        }

        $(this).val(value);
    });

    // 手机号格式验证
    $('input[type="tel"]').on('blur', function() {
        const phone = $(this).val();
        const phoneRegex = /^1[3-9]\d{9}$/;

        if (phone && !phoneRegex.test(phone)) {
            $(this).addClass('is-invalid');
            $(this).next('.invalid-feedback').text('请输入有效的手机号码');
        } else {
            $(this).removeClass('is-invalid');
        }
    });

    // 邮箱格式验证
    $('input[type="email"]').on('blur', function() {
        const email = $(this).val();
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

        if (email && !emailRegex.test(email)) {
            $(this).addClass('is-invalid');
            $(this).next('.invalid-feedback').text('请输入有效的邮箱地址');
        } else {
            $(this).removeClass('is-invalid');
        }
    });

    // 密码强度检查
   /* $('input[type="password"]').on('input', Utils.debounce(function() {
        const password = $(this).val();
        if (password.length < 6) {
            $(this).addClass('is-invalid');
            $(this).next('.invalid-feedback').text('密码长度至少6位');
        } else {
            $(this).removeClass('is-invalid');
        }
    }, 300));*/

    // 实时时间显示
    function updateTime() {
        const now = new Date();
        const timeStr = Utils.formatDate(now, 'YYYY-MM-DD HH:mm:ss');
        $('.current-time').text(timeStr);
    }

    if ($('.current-time').length > 0) {
        updateTime();
        setInterval(updateTime, 1000);
    }

    // 打印功能
    $('.btn-print').on('click', function() {
        window.print();
    });

    // 导出功能
    $('.btn-export').on('click', function() {
        const table = $(this).data('table') || '.data-table';
        const filename = $(this).data('filename') || 'data.csv';

        exportTableToCSV(table, filename);
    });

    // 全选/取消全选
    $('.select-all').on('change', function() {
        const isChecked = $(this).prop('checked');
        $('.select-item').prop('checked', isChecked);
    });

    // 批量操作
    $('.btn-batch-action').on('click', function() {
        const selectedIds = [];
        $('.select-item:checked').each(function() {
            selectedIds.push($(this).val());
        });

        if (selectedIds.length === 0) {
            Utils.showWarning('请至少选择一项');
            return;
        }

        const action = $(this).data('action');
        const url = $(this).data('url');

        Utils.confirm(`确定要对选中的 ${selectedIds.length} 项执行此操作吗？`, function() {
            Utils.submitForm(url, { ids: selectedIds, action: action }, 'POST', function() {
                window.location.reload();
            });
        });
    });

    // 标签页切换保持滚动位置
    $('a[data-bs-toggle="tab"]').on('shown.bs.tab', function (e) {
        localStorage.setItem('activeTab', $(e.target).attr('href'));
    });

    const activeTab = localStorage.getItem('activeTab');
    if (activeTab) {
        const tab = $('a[href="' + activeTab + '"]');
        if (tab.length) {
            tab.tab('show');
        }
    }

    // 自动保存表单数据
    $('.autosave').on('input', Utils.debounce(function() {
        const form = $(this).closest('form');
        const data = form.serialize();
        const key = 'autosave_' + window.location.pathname;
        localStorage.setItem(key, data);
    }, 1000));

    // 恢复自动保存的数据
    const autosaveKey = 'autosave_' + window.location.pathname;
    const savedData = localStorage.getItem(autosaveKey);
    if (savedData) {
        $('.autosave-form').deserialize(savedData);
    }

    // 页面卸载前清除自动保存的数据
    $(window).on('beforeunload', function() {
        localStorage.removeItem(autosaveKey);
    });
});

/**
 * 导出表格数据为CSV
 * @param {string} tableSelector 表格选择器
 * @param {string} filename 文件名
 */
function exportTableToCSV(tableSelector, filename) {
    const table = document.querySelector(tableSelector);
    if (!table) return;

    const rows = table.querySelectorAll('tr');
    const csv = [];

    for (let i = 0; i < rows.length; i++) {
        const row = [], cols = rows[i].querySelectorAll('td, th');

        for (let j = 0; j < cols.length; j++) {
            // 清理数据
            let data = cols[j].innerText.replace(/(\r\n|\n|\r)/gm, '');
            data = data.replace(/(\s\s)/gm, ' ');
            data = data.replace(/"/g, '""');

            // 添加引号
            row.push('"' + data + '"');
        }

        csv.push(row.join(','));
    }

    // 下载CSV文件
    const csvString = csv.join('\n');
    const blob = new Blob([csvString], { type: 'text/csv;charset=utf-8;' });
    const link = document.createElement('a');

    if (navigator.msSaveBlob) {
        navigator.msSaveBlob(blob, filename);
    } else {
        link.href = URL.createObjectURL(blob);
        link.download = filename;
        link.style.display = 'none';
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
    }
}

/**
 * 反序列化表单数据
 * @param {string} data 序列化的表单数据
 */
$.fn.deserialize = function(data) {
    const form = this;
    const params = new URLSearchParams(data);

    params.forEach(function(value, key) {
        const input = form.find('[name="' + key + '"]');
        if (input.length) {
            const type = input.attr('type');

            if (type === 'checkbox' || type === 'radio') {
                input.filter('[value="' + value + '"]').prop('checked', true);
            } else {
                input.val(value);
            }
        }
    });
};



// Promise错误处理
window.addEventListener('unhandledrejection', function(event) {
    console.error('Unhandled promise rejection:', event.reason);
    Utils.showError('操作失败：' + (event.reason?.message || '未知错误'));
});