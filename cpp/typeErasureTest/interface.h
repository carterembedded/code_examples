#ifndef __INTERFACE_H__
#define __INTERFACE_H__

template <class T_Result, class T_Send>
class interface
{
public:
  virtual T_Result getResult() = 0;
  virtual void setSend(T_Send dataToSend) = 0;
};

#endif /* __INTERFACE_H_ */
