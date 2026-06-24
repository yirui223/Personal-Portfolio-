#自定义SingleNode类，表示，节点类
class SingleNode:
    #初始化属性
    def __init__(self,item):
        self.item = item  #元素域（数值域）
        self.next = None    #链接域（地址域）

class SingleLinkedList:
    #初始化属性
    def __init__(self,node=None):
        self.head = node    #链表的头结点，指向第一个节点
        #(cur = self.head = node = SingleNode('小脑'))

    # 链表是否为空
    def is_empty(self):
        #思路：判断头结点是否为None,如果为None,则链表为空
        #写法1：if else
        # if self.head is None:
        #     return True
        # else:
        #     return False
        #方法二：三元表达式
        #return True if self.head is None else False
        #方法三：最终版 （if 后面接的是布尔值（self.head is None））
        return self.head is None

    #链表长度
    def length(self):
        #创建游标（表示当前节点），默认从头结点开始
        cur = self.head
        #定义计数器
        count = 0
        #开始遍历，只要当前节点不为空，就一直循环
        while cur is not None:
            #计数器 + 1，然后cur指向下一个节点
            count += 1
            cur = cur.next
        #循环结束，列表长度已经获取了，返回即可
        return count  #不能用print，因为只能看，不能拿来用

    #遍历整个链表
    def travel(self):
        # 创建游标（表示当前节点），默认从头结点开始
        cur = self.head
        # 开始遍历，只要当前节点不为空，就一直循环
        while cur is not None:
            #打印当前节点的数值域
            print(f'数值域为：{cur.item}')
            #修改当前节点移动到下个节点
            cur = cur.next

    #链表头部添加元素
    def add(self,item):
        #创建新节点
        new_node = SingleNode(item)
        #设置新节点的地址域 指向 头结点 （第一步）
        new_node.next = self.head
        #设置头结点指向新节点
        self.head = new_node

    #链表尾部添加元素
    def append(self,item):
        # 创建新节点
        new_node = SingleNode(item)
        #判断当前节点为空，直接设置头结点即可
        if self.is_empty():
            self.head = new_node
        else:
            #走到这里说明链表不为空，需要找到尾节点
            #创建游标（表示当前节点），默认从头结点开始
            cur = self.head
            #开始遍历，只要当前节点不为空，就一直循环
            while cur.next is not None:
                #游标开始后移
                cur = cur.next
            #走到这里 cur就是最后一个节点，设置它的地址指向新节点就可以
            cur.next = new_node

    #指定位置添加元素（把要添加的元素放在想放的位置上，其他人后移）
    def insert(self,pos,item):
        #判断索引是否越界，如果<=0往前添加
        if pos <= 0:
            self.add(item)
        #如果索引 >= 长度的，就往后加
        elif pos >= self.length():
            self.append(item)
        else:
            #走这里说明索引合法，需要插入中间的值，需找到插入元素前的那个元素
            #创建游标（表示当前节点），默认从头结点开始
            cur = self.head
            #定义变量，记录当前节点的位置（可以理解为索引，但是不是，因为链表没有索引）
            count = 0
            #只要当前节点的位置 < pos - 1,就一直循环
            while count < pos - 1:
                cur = cur.next
                count += 1
            #走到这里，cur就是插入位置前的那个节点，先封装新内容为新节点
            new_node = SingleNode(item)
            #设置 新的节点的地址域 指向 插入位置前的那个节点的 地址域
            new_node.next = cur.next
            #设置 插入位置前的那个节点的地址域 指向 新节点
            cur.next = new_node

    #移除节点
    def remove(self,item):
        #创建游标（表示当前节点）， 默认从头节点开始
        cur = self.head
        #定义变量， 记录要删除节点的 前驱节点
        pre = None
        # 开始遍历，只要当前节点不为空，就一直循环 （当要删除的节点不在链表中，链表就会走到头，cur = None,循环就会自动结束，退出）
        while cur is not None:
            #判断当前节点内容是否为要删除的节点(情况一：是要删除的内容，情况二：不是要删除的内容）
            if cur.item == item:
                #判断要删除的节点是否是头结点
                if cur == self.head:
                    #直接设置头结点为当前节点的下一个节点（当前节点的地址域）
                    self.head = cur.next
                else:
                    #要删除的节点不是头结点,直接设置前置节点的地址域 指向 当前节点的地址域即可
                    pre.next = cur.next
                    cur.next = None #删除节点断开链接
                #走到这里，说明删除成功，直接返回即可。即：结束程序
                return
            else:
                #走这里说明当前节点不是要删除的节点，就游标后移，前驱节点后移。
                pre = cur
                cur = cur.next

    #查找节点是否存在
    def search(self,item):
        #创建游标（表示当前节点），默认从头节点开始
        cur = self.head
        # 只要当前节点不为空，就一直循环
        while cur is not None:
            #判断当前的节点是否为要找的节点，如果是就返回True
            if cur.item == item:
                return True
            #如果当前节点不是要找的，就 游标后移
            cur = cur.next
        #走到这里所有节点都找完了，还没找到
        return False


if __name__ == '__main__':
    # #测试节点类
    # node1=SingleNode(10)
    # #打印当前节点的 元素域 和 链接域
    # print(f'元素域：{node1.item}')   #10
    # print(f'链接域：{node1.next}')   #none
    # print(f'node1的对象：{node1}')   #<__main__.SingleNode object at 0x103b7f230>  地址
    # print(f'node1的类型：{type(node1)}')  #<class '__main__.SingleNode'>
    # print('-' * 23)
    #
    # #测试链表类
    # my_linkedlist=SingleLinkedList(node1)
    # print(f'头结点为：{my_linkedlist.head}') #头结点地址<__main__.SingleNode object at 0x1055d7230>
    # #所以可以用my_linkedlist.head代替node1
    # print(f'头结点的元素域{my_linkedlist.head.item}')  #10
    # print(f'头结点的链接域{my_linkedlist.head.next}')   #none

    #完整测试
    #创建节点类
    node1 = SingleNode('小脑')
    #将上述的节点作为头结点
    my_linkedlist = SingleLinkedList(node1)
    #打印头结点
    print(f'头结点为：{my_linkedlist.head}')
    print(f'头结点的元素域：{my_linkedlist.head.item}')
    print(f'头结点的链接域：{my_linkedlist.head.next}')
    print('-' * 23)

    #测试链表是否为空
    print(my_linkedlist.is_empty())
    print('-' * 23)

    #测试 往头部 添加元素
    my_linkedlist.add('小粉球')
    my_linkedlist.add('小狐狸')

    #测试 往尾部 添加元素
    my_linkedlist.append('01')
    my_linkedlist.append('02')

    #测试 指定位置 添加元素
    my_linkedlist.insert(-3,'0.75')
    my_linkedlist.insert(12,'小韩')
    my_linkedlist.insert(3,'小草')
    my_linkedlist.insert(5, '夜影')

    #测试删除元素
    my_linkedlist.remove('0.75')
    my_linkedlist.remove('小')

    #测试查找元素
    print('元素是否存在：')
    print(my_linkedlist.search('01'))
    print(my_linkedlist.search('00'))
    print('-' * 23)


    #测试链表长度
    print(f'链表长度为：{my_linkedlist.length()}')
    print('-' * 23)

    #测试遍历表
    my_linkedlist.travel()
    print('-' * 23)