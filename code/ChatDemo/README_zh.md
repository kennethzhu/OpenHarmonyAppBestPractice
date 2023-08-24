# 聊天应用优化

## 介绍

这是一个仿聊天类应用，将聊天模块拆分成多个hap包。

关于本应用工程的优化文章，可以访问[https://rtos_yuan.gitee.io/oh_app/#/perf_03_list_lazyforeach](https://rtos_yuan.gitee.io/oh_app/#/perf_03_list_lazyforeach)。

## 效果预览（优化后效果）
| 主页                                 |
|------------------------------------|
| |

优化说明

## 工程结构

主工程
```
entry/src/main/ets
|---/utils                                    
|   |---Logger.ets
...
|---/pages                                                               
|   |---Index.ets            
...
|---/view
|   |---View1.ets                         
|   |---View2.ets     
...
|---/viewModel
|   |---viewModel1.ets                         
|   |---viewModel2.ets
...
|---resources/images
                                            
```

聊天列表模块（chatList）
```
chatList/src/main/ets
|---/utils
|   |---BasicDataSource.ets
|   |---Logger.ets
...
|---/pages                                                               
|   |---ChatListDisplayPage.ets
...
|---/view
|   |---View1.ets
|   |---View2.ets     
...
|---/viewModel
|   |---viewModel1.ets                         
|   |---viewModel2.ets
...
|---resources/images
                                            
```
