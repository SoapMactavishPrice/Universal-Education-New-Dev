global class ContactWrapper
{
public Boolean isSelected {get;set;}
public Contact cont{get;set;}  
    //Contact cont,Boolean isSelected
    public ContactWrapper(Contact cont,Boolean isSelected)
    {
      this.cont= cont;
     // cont=new Contact();
      this.isSelected= isSelected;

    }
    public ContactWrapper(Contact cont){
        this.cont = cont;
    }
    
}