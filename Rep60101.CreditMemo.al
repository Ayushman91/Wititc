report 60101 "Credit Memo Report"
{
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    DefaultLayout = RDLC;
    RDLCLayout = 'Layouts\CreditMemo.rdl';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            column(No_; "No.") { }
            column(CompanyInfoPic1; CompanyInfo.Picture) { }
            column(CompanyInfoPic2; CompanyInfo."Picture 2") { }
            column(CompanyInfoBankName; CompanyInfo."Bank Name") { }
            //column(CompanyInfo; CompanyInfo."Brand Color Code") { }
            column(CompanyInfoSwiftCode; CompanyInfo."SWIFT Code") { }
            column(CompanyInfoBankAcc; CompanyInfo."Bank Account No.") { }
            column(Promised_Delivery_Date; "Promised Delivery Date") { }
            column(External_Document_No_; "External Document No.") { }
            column(Payment_Terms_Code; "Payment Terms Code") { }
            column(Posting_Date; "Posting Date") { }
            column(Salesperson_Code; "Salesperson Code") { }
            column(CompanyAddr1; CompanyAddr[1]) { }
            column(CompanyAddr2; CompanyAddr[2]) { }
            column(CompanyAddr3; CompanyAddr[3]) { }
            column(CompanyAddr4; CompanyAddr[4]) { }
            column(CompanyAddr5; CompanyAddr[5]) { }
            column(CompanyAddr6; CompanyAddr[6]) { }
            column(CompanyAddr7; CompanyAddr[7]) { }
            column(CompanyAddr8; CompanyAddr[8]) { }
            column(SellToAddr1; SellToAddr[1]) { }
            column(SellToAddr2; SellToAddr[2]) { }
            column(SellToAddr3; SellToAddr[3]) { }
            column(SellToAddr4; SellToAddr[4]) { }
            //column(SellToAddr5; SellToAddr[5]) { }
            column(ShipToAddr1; ShipToAddr[1]) { }
            column(ShipToAddr2; ShipToAddr[2]) { }
            column(ShipToAddr3; ShipToAddr[3]) { }
            column(ShipToAddr4; ShipToAddr[4]) { }
            //column(ShipToAddr5; ShipToAddr[5]) { }
            column(Remark1Caption; Remark1Caption) { }
            column(RegistrationNoCaption; RegistrationNoCaption) { }
            column(DateCaption; DateCaption) { }
            column(NoteCaption; NoteCaption) { }
            column(Note2Caption; Note2Caption) { }
            column(SoldToCaption; SoldToCaption) { }
            column(DeliverToCaption; DeliverToCaption) { }
            column(IssuedByCaption; IssuedByCaption) { }
            column(Assigned_User_ID; "Assigned User ID") { }
            column(ModelNoCaption; ModelNoCaption) { }
            column(DeliveryDateCaption; DeliveryDateCaption) { }
            column(SignatureStampCaption; SignatureStampCaption) { }
            column(CustomerCopyCaption; CustomerCopyCaption) { }
            column(TermofPaymentCaption; TermofPaymentCaption) { }
            column(TotalCaption; TotalCaption) { }
            column(SubtotalCaption; SubtotalCaption) { }
            column(GSTCaption; GSTCaption) { }
            column(BankNameCaption; BankNameCaption) { }
            column(BanckAccNoCaption; BanckAccNoCaption) { }
            column(SwiftCodeCaption; SwiftCodeCaption) { }
            column(SalespersonCaption; SalespersonCaption) { }
            column(ChequeCommentCaption; ChequeCommentCaption) { }
            column(Note3Caption; Note3Caption) { }
            column(PurchaseOrderNoCaption; PurchaseOrderNoCaption) { }
            column(FOFCaption; FOFCaption) { }
            column(DocumentNameCaption; DocumentNameCaption) { }
            column(Remark2Caption; Remark2Caption) { }
            column(Remark3Caption; Remark3Caption) { }
            column(DocumentName2Caption; DocumentName2Caption) { }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemLinkReference = "Sales Header";
                column(Unit_Price; "Unit Price") { }
                column(Description; Description) { }
                column(Location_Code; "Location Code") { }
                column(Quantity; Quantity) { }
                column(No; "No.") { }
                column(Document_No_; "Document No.") { }
                column(Amount; Amount) { }
                column(Line_Amount; "Line Amount") { }
                column(Line_Discount_Amount; "Line Discount Amount") { }
                column(Amount_Including_VAT; "Amount Including VAT") { }
                column(GST; GST) { }
                column(Subtotal; Subtotal) { }
                column(Total; Total) { }
                trigger OnPreDataItem()
                begin

                end;

                trigger OnAfterGetRecord()
                begin
                    Clear(GstVar);
                    SL.Reset();
                    SL.SetFilter("VAT %", '<>%1', 0);
                    if SL.FindFirst() then
                        GstVar := SL."VAT %";

                    Clear(Subtotal);
                    Clear(GST);
                    Clear(Total);
                    SL.Reset();
                    SL.SetRange("Document No.", SH."No.");
                    SL.SetRange("Document No.", "Sales Line"."Document No.");
                    if SL.FindSet() then begin
                        SL.CalcSums(Quantity, "Amount Including VAT", "Unit Price", "Line Amount", "Line Discount Amount");
                    end;
                    Subtotal := SL."Line Amount";
                    GST := SL."Amount Including VAT" - SL.Amount;
                    Total := SL."Amount Including VAT";
                end;

                trigger OnPostDataItem()
                begin

                end;
            }
            trigger OnPreDataItem()
            begin

            end;

            trigger OnAfterGetRecord()
            begin
                Clear(CompanyAddr);
                CompanyAddr[1] := CompanyInfo.Name;
                CompanyAddr[2] := CompanyInfo.Address + CompanyInfo."Address 2" + ' , ' + CompanyInfo.City + ' ' + CompanyInfo."Post Code";
                CompanyAddr[3] := CompanyInfo."Phone No.";
                CompanyAddr[4] := CompanyInfo."Fax No.";
                CompanyAddr[5] := CompanyInfo."E-Mail";
                CompanyAddr[6] := CompanyInfo."Home Page";
                CompanyAddr[7] := RegistrationNoCaption;
                CompanyAddr[8] := CompanyInfo."Registration No.";

                Clear(SellToAddr);
                SellToAddr[1] := "Sales Header"."Sell-to Customer Name";
                SellToAddr[2] := "Sales Header"."Sell-to Address";
                if "Sales Header"."Sell-to Address 2" <> '' then
                    SellToAddr[3] := "Sales Header"."Sell-to Address 2";
                if "Sales Header"."Sell-to City" <> '' then
                    if SellToAddr[3] <> '' then
                        SellToAddr[3] += ',' + "Sales Header"."Sell-to City"
                    else
                        SellToAddr[3] := "Sales Header"."Sell-to City";
                SellToAddr[4] := "Sales Header"."Sell-to Post Code";
                CompressArray(SellToAddr);

                Clear(ShipToAddr);
                ShipToAddr[1] := "Sales Header"."Bill-to Name";
                ShipToAddr[2] := "Sales Header"."Bill-to Address";
                if "Ship-to Address 2" <> '' then
                    ShipToAddr[3] := "Ship-to Address 2";
                if "Sales Header"."Ship-to City" <> '' then
                    if ShipToAddr[3] <> '' then
                        ShipToAddr[3] := ',' + "Ship-to City"
                    else
                        ShipToAddr[3] := "Ship-to City";
                ShipToAddr[4] := "Sales Header"."Ship-to Post Code";
                CompressArray(ShipToAddr);
            end;

            trigger OnPostDataItem()
            begin

            end;
        }
    }

    requestpage
    {
        layout
        {
            area(Content)
            {
                group(GroupName)
                {
                    // field(Name; SourceExpression)
                    // {
                    //     ApplicationArea = All;

                    // }
                }
            }
        }

        actions
        {
            area(processing)
            {
                action(ActionName)
                {
                    ApplicationArea = All;

                }
            }
        }
    }
    trigger OnInitReport()
    begin

    end;

    trigger OnPreReport()
    begin
        CompanyInfo.Get();
        CompanyInfo.CalcFields(Picture);
        CompanyInfo.CalcFields("Picture 2");
    end;

    trigger OnPostReport()
    begin

    end;


    var
        myInt: Integer;
        SH: Record "Sales Header";
        SL: Record "Sales Line";
        CompanyInfo: Record "Company Information";
        SellToAddr: array[10] of Text;
        ShipToAddr: array[10] of Text;
        CompanyAddr: array[10] of Text;
        RegistrationNoCaption: Label 'Co. Reg. No.';
        Remark1Caption: Label 'Remark: ';
        Remark2Caption: Label 'Remarks: Price Variance';
        Remark3Caption: Label 'Refer to our Invoice No.';
        NoteCaption: Label 'The Debt due under this invoice has been assigned to and is payable only to:';
        Note2Caption: Label '20 Pasir Panjang Road (East Lobby) #12-21 MapleTree Business City, Singapore 117439';
        Note3Caption: Label 'If this invoice is not found to be correct in any respect, HSBC must be notified immediately.';
        DocumentNameCaption: Label 'Credit Note';
        DocumentName2Caption: Label 'Sales Invoice';
        ChequeCommentCaption: Label 'Cheques should be made payable to:';
        SignatureStampCaption: Label 'Authorized Signature ';
        CustomerCopyCaption: Label 'Customer Copy';
        IssuedByCaption: Label 'Issued By:';
        SoldToCaption: Label 'Sold To:';
        DeliverToCaption: Label 'Deliver To:';
        GstVar: Decimal;
        Subtotal: Decimal;
        GST: Decimal;
        Total: Decimal;
        SalespersonCaption: Label 'Salesperson';
        PurchaseOrderNoCaption: Label 'Purchase Order No.';
        DeliveryDateCaption: Label 'Delivery Date';
        DateCaption: Label 'Date';
        QuantityCaption: Label 'Quantity';
        TermofPaymentCaption: Label 'Term of Payment';
        UnitpriceCaption: Label 'Unit Price';
        AmountCaption: Label 'Amount';
        SubtotalCaption: Label 'Sub-Total   :';
        GSTCaption: Label 'GST  :';
        TotalCaption: Label 'Total  :';
        ModelNoCaption: Label 'Model No.';
        DescriptionCaption: Label 'Description';
        LocationCodeCaption: Label 'Location Code';
        FOFCaption: Label 'E & O E';
        BankNameCaption: Label 'Bank Name :';
        BanckAccNoCaption: Label 'Bank Account No. :';
        SwiftCodeCaption: Label 'SWIFT CODE :';
}