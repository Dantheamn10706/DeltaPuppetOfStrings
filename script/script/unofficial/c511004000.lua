--Anime Style Duel
--Scripted by Daniel
local s,id=GetID()
if s then
	function s.initial_effect(c)
	aux.EnableExtraRules(c,s,s.init)
end

P1count = 0
P2count = 0
P3count = 0
P4count = 0

function s.init(c)
--summon face-up defense
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_LIGHT_OF_INTERVENTION)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetTargetRange(1,1)
	Duel.RegisterEffect(e1,0)
	--ZEXAL NUMBER rule
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetTargetRange(LOCATION_ONFIELD,LOCATION_ONFIELD)
	e2:SetTarget(s.Target)
	e2:SetValue(s.indval)
	Duel.RegisterEffect(e2,0)
end
end
if not id then id=511004000 end
if not DestinyDraw then
	DestinyDraw={}
	aux.GlobalCheck(DestinyDraw,function()
		DestinyDraw[0]=nil
	end)
	local function finishsetup()
		local e3=Effect.GlobalEffect()
		e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_PREDRAW)
		e3:SetOperation(DestinyDraw.drop)
		Duel.RegisterEffect(e3,0)
	end
	s.listed_series={0x48}
function s.indval(e,c)
	return not c:IsSetCard(0x48) and not c:IsAttribute(ATTRIBUTE_DIVINE)
end
function s.Target(e,c)
	return c:IsSetCard(0x48) and not c:IsDisabled(c)
end
function s.cfilter(c)
	return  (c:IsSetCard(0x7f))
end
function s.dfilter(c)
	return  (c:GetCode()~=24696097)
end
function DestinyDraw.drop(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return end
	local op
	if Duel.GetLP(Duel.GetTurnPlayer())<=1000 and Duel.SelectYesNo(Duel.GetTurnPlayer(),aux.Stringid(id,0))then
		if (Duel.GetTurnPlayer() == 0 and P1count>=1) or (Duel.GetTurnPlayer() == 1 and P2count>=1) or
		   (Duel.GetTurnPlayer() == 2 and P3count>=1) or (Duel.GetTurnPlayer() == 3 and P4count>=1)then
			if Duel.IsExistingMatchingCard(s.cfilter,Duel.GetTurnPlayer(),LOCATION_ONFIELD|LOCATION_GRAVE|LOCATION_EXTRA,0,1,nil) then
				op=Duel.SelectOption(Duel.GetTurnPlayer(),aux.Stringid(511004000,1),aux.Stringid(511004000,4))
				if op>0 then
					op=op+1
				end
			else
				op=0
			end
		else
			if Duel.IsExistingMatchingCard(s.cfilter,Duel.GetTurnPlayer(),LOCATION_ONFIELD|LOCATION_GRAVE|LOCATION_EXTRA,0,1,nil) then
				op=Duel.SelectOption(Duel.GetTurnPlayer(),aux.Stringid(511004000,1),aux.Stringid(511004000,2),aux.Stringid(id,4))
			else
				op=Duel.SelectOption(Duel.GetTurnPlayer(),aux.Stringid(511004000,1),aux.Stringid(511004000,2))
			end
		end
		if op==0 then
			Duel.Hint(HINT_CARD,Duel.GetTurnPlayer(),id)
				Duel.Hint(HINT_SELECTMSG,Duel.GetTurnPlayer(),HINTMSG_ATOHAND)
				local g=Duel.SelectMatchingCard(Duel.GetTurnPlayer(),s.thfilter,Duel.GetTurnPlayer(),LOCATION_DECK,0,1,1,nil)
				local tc=g:GetFirst()
				if tc then
					Duel.ShuffleDeck(Duel.GetTurnPlayer())
					Duel.MoveSequence(tc,0)
				end
		elseif op==1 then
			if not (Duel.GetTurnPlayer() == 0 and P1count>=1) or (Duel.GetTurnPlayer() == 1 and P2count>=1)then
				if not Duel.SelectYesNo(Duel.GetTurnPlayer(),aux.Stringid(id,3)) then
					s.announce_filter={TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP,OPCODE_ISTYPE,OPCODE_ALLOW_ALIASES}
					local ac=Duel.AnnounceCard(Duel.GetTurnPlayer(),table.unpack(s.announce_filter))
					local token=Duel.CreateToken(Duel.GetTurnPlayer(),ac)
					Duel.SendtoDeck(token,Duel.GetTurnPlayer(),0,REASON_EFFECT)
					if Duel.GetTurnPlayer() == 0 then
						P1count=P1count+1
					elseif Duel.GetTurnPlayer() == 1 then
					P2count=P2count+1
					elseif Duel.GetTurnPlayer() == 2 then
					P2count=P3count+1
					elseif Duel.GetTurnPlayer() == 3 then
					P2count=P4count+1
					end
				end
			end
		elseif op==2 then
			if not Duel.SelectYesNo(Duel.GetTurnPlayer(),aux.Stringid(id,3)) then
				Duel.Hint(HINT_SELECTMSG,Duel.GetTurnPlayer(),HINTMSG_REMOVE)
				local g=Duel.SelectMatchingCard(Duel.GetTurnPlayer(),Card.IsAbleToRemove,Duel.GetTurnPlayer(),LOCATION_DECK,0,1,1,nil,Duel.GetTurnPlayer(),POS_FACEDOWN)
				local tcs=g:GetFirst()
				Duel.Remove(tcs,POS_FACEDOWN,REASON_EFFECT)
				Duel.ShuffleDeck(Duel.GetTurnPlayer())
				s.announce_filter={TYPE_MONSTER+TYPE_SPELL+TYPE_TRAP,OPCODE_ISTYPE,OPCODE_ALLOW_ALIASES}
				local ac=Duel.AnnounceCard(Duel.GetTurnPlayer(),table.unpack(s.announce_filter))
				local token=Duel.CreateToken(Duel.GetTurnPlayer(),ac)
				Duel.SendtoDeck(token,Duel.GetTurnPlayer(),0,REASON_EFFECT)
			end
		end
	end
end
		--Debug.Message(Duel.IsExistingMatchingCard(s.cfilter,Duel.GetTurnPlayer(),LOCATION_ONFIELD|LOCATION_GRAVE|LOCATION_EXTRA,0,1,nil))
		-- Debug.Message(Duel.GetTurnPlayer())
				
			
			

	finishsetup()
end