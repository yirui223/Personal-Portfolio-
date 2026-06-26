# 定义函数 binary_search_recursion(),表示 二分查找
def binary_search_recursion(my_list,target):
    """
    该函数是 二分查找的递归版，实现查找指定元素是否在列表中
    :param my_list: 待查找的列表
    :param target:  要查找的元素
    :return: True:找到了 vice versa
    """
    # 先判断列表是否为空
    #获取列表的长度
    n = len(my_list)
    if n == 0:
        return False
    # 获取列表的 中值（的索引）
    mid = n//2  #向下取整
    #比较 要查找的元素 和 中值
    if my_list[mid] == target:
        return True
    elif target < my_list[mid]:
        # 如果要查找的元素 比 中值小，去前半段（中值前） 查找， 递归调用
        return binary_search_recursion(my_list[:mid],target)
    else:
        # 如果要查找元素 比 中值大， 去后半段（中值后） 查找， 递归调用
        return binary_search_recursion(my_list[mid+1:],target)

    # 到这里说明遍历完毕，好没找到， 返回FALSE
    return False

#定义函数 binary_search(),表示 二分查找 没有递归的版本
def binary_search(my_list,target):
    # 定义变量start, end 分别表示列表的开始 和 结束索引
    start = 0
    end = len(my_list)-1

    # 循环查找，只要满足条件就一直查找
    while start <= end:
        #计算中间值的索引
        mid = (start + end)//2
        # 比较 要查找的元素 和 中值
        if my_list[mid] == target:
            return True
        elif target < my_list[mid]:
            # 如果要查找的元素 比 中值小，去前半段（中值前） 查找。 即：修改end的值
            end = mid - 1
        else:
            # 如果要查找的元素 比 中值大，去后半段（中值前） 查找。 即：修改start的值
            start = mid + 1
        # 到这里说明遍历完毕，好没找到， 返回FALSE
    return False



#test
if __name__ == '__main__':
    # 定义列表
    my_list = [1,2,4,5,6,7,8,9,10]    #列表需要是升序的
    print(binary_search_recursion(my_list,10))
    print(binary_search_recursion(my_list, 11))

    print(binary_search(my_list, 10))