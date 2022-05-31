namespace Progect.Model
{
    /// <summary>
    /// Модель журнала заказов
    /// </summary>
    /// 
    public class Order_Log
    {
        public int ID_Order_Log { get; set; }
        public float Quantity_Component { get; set; }
        public int Component_Order_ID { get; set; }
        public int Application_ID { get; set; }
        public decimal Price { get; set; }
        public int List_Status_ID { get; set; }
    }
}
